# A sample Guardfile
# More info at https://github.com/guard/guard#readme

# Add files and commands to this file, like the example:
#   watch(%r{file/path}) { `command(s)` }
#
notification :libnotify, transient: true, timeout: 1

guard 'shell' do
  watch(/(.*).vim/) do
    unless system('vim-flavor test')
      n 'vspec', 'failure', :failed
    end
  end
end
