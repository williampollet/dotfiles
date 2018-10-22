class ModifiedFiles
  def initialize(test_command:)
    @modified_files = `git diff --name-status master | egrep -h "^M|^A" | cut -c 3-`.split("\n")
    @moved_files = `git diff --name-status master | egrep -h "^R"`.split("\n")
    @test_command = test_command
    @specs_to_execute = []
  end

  def call
    list_files_to_execute
    list_moved_files_to_execute
    run_specs
  end

  private

  attr_reader :modified_files, :specs_to_execute, :test_command, :moved_files

  def list_files_to_execute
    modified_files.each do |f|
      analize_file(f)
    end
  end

  def list_moved_files_to_execute
    moved_files.each do |f|
      file = f.split("\t").last
      analize_file(file)
    end
  end

  def analize_file(f)
    if f.match(files_to_match)
      puts "New file found, searching for specs..."

      spec_path = f.gsub('app/', 'spec/').gsub('.rb', '_spec.rb')

      if File.exists?(spec_path)
        puts "spec found for file #{f}, putting #{spec_path} in the list of specs to run"
        specs_to_execute << spec_path
      else
        create_new_spec(spec_path, f)
      end
    elsif f.match(/spec/) && !specs_to_execute.include?(f)
      puts "new spec found, putting #{f} in the list of specs to run"
      specs_to_execute << f
    end
  end

  def run_specs
    return if specs_to_execute.empty?

    system("#{test_command} #{specs_to_execute.join(' ')}")
    raise 'spec failed or skipped!' if $?.exitstatus != 0
  end

  def create_new_spec(spec_path, f)
    puts "no spec found for file #{f}, creating spec at #{spec_path}"
    f = File.open(spec_path, 'w') do |file|
      file.write(template(spec_path))
    end
    raise 'spec to write!'
  end

  def template(spec_path)
    class_name = File.basename(spec_path).gsub('_spec.rb', '').split('_').map(&:capitalize).join
    template = "require \'rails_helper\'\n\nRSpec.describe #{class_name} do\nend"
  end

  def files_to_match
    /app\/interactors\/|app\/models|app\/mails\/|app\/graph\/mutations\/|app\/graph\/types\/|app\/forms\/|app\/apis\/|app\/proppers\//
  end
end

ModifiedFiles.new(test_command: 'zeus test').call
