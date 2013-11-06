# A sample Guardfile
# More info at https://github.com/guard/guard#readme

# Add files and commands to this file, like the example:
#   watch(%r{file/path}) { `command(s)` }
#

ignore /\.vim-flavor/

notification :libnotify, transient: true, timeout: 1
guard 'shell' do
  watch(/^(t|autoload|plugin)\/.*\.vim$/) do |m|
    puts m.inspect
    unless system('vim-flavor test')
      n 'vspec', 'failure', :failed
    end
  end
end
