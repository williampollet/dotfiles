new_files = `git diff --name-status master | grep "^A" | cut -c 3-`.split("\n")

if new_files.map{ |f| f.match(/app\/interactors/) }.any?
  puts "new files found, searching for specs."
end

new_files.each do |f|
  if f.match(/app\/interactors/) || f.match(/app\/models/)
    spec_path = f.gsub('app/', 'spec/').gsub('.rb', '_spec.rb')

    if File.exists?(spec_path)
      puts "spec found for file #{f}, running zeus test #{spec_path}"
      system("zeus test #{spec_path}")
      raise 'spec failed!' if $?.exitstatus != 0
    else
      puts "no spec found for file #{f}, creating spec at #{spec_path}"
      class_name = File.basename(f).gsub('.rb', '').split('_').map(&:capitalize).join
      template = "require \'rails_helper\'\n\nRSpec.describe #{class_name} do\nend"
      f = File.open(spec_path, 'w') do |file|
        file.write(template)
      end
      raise 'spec to write!'
    end
  end
end
