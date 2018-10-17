new_files = `git diff --name-status master | cut -c 3-`.split("\n")

specs_to_skip = []

new_files.each do |f|
  if f.match(/app\/interactors/) || f.match(/app\/models/) || f.match(/app\/mails/)
    # Scan for interactors or models

    puts "New file found, searching for specs..."

    spec_path = f.gsub('app/', 'spec/').gsub('.rb', '_spec.rb')

    specs_to_skip << spec_path

    if File.exists?(spec_path)
      puts "spec found for file #{f}, running zeus test #{spec_path}"
      system("zeus test #{spec_path}")
      raise 'spec failed!' if $?.exitstatus == 1
      raise 'Oops, the spec has been skipped by zeus' if $?.exitstatus == 123
    else
      puts "no spec found for file #{f}, creating spec at #{spec_path}"
      class_name = File.basename(f).gsub('.rb', '').split('_').map(&:capitalize).join
      template = "require \'rails_helper\'\n\nRSpec.describe #{class_name} do\nend"
      f = File.open(spec_path, 'w') do |file|
        file.write(template)
      end
      raise 'spec to write!'
    end
  elsif f.match(/spec/) && !specs_to_skip.include?(f)
  # scan for new specs
    system("zeus test #{f}")
    raise 'spec failed!' if $?.exitstatus == 1
    raise 'Oops, the spec has been skipped by zeus' if $?.exitstatus == 123
  end
end
