require 'fileutils'
require 'aruba/cucumber'

$:.unshift(File.join(File.dirname(__FILE__), '..', '..', 'lib'))

HEROKU_PLUGIN_PATH = File.expand_path('~/.heroku/plugins')
PLUGIN_PATH = File.join(HEROKU_PLUGIN_PATH, 'sauce-testing')


Before do
  work_dir = File.expand_path(File.dirname(__FILE__) + '/../../')

  unless File.exists? HEROKU_PLUGIN_PATH
    FileUtils.mkdir_p HEROKU_PLUGIN_PATH
  end

  FileUtils.ln_sf(work_dir, PLUGIN_PATH)


  # Let's shuffle around the ~/.sauce/ondemand.yml if it exists
  # We don't need to move the ondemand.yml in the current directory since Aruba
  # shifts our $CWD to tmp/cucumber
  @moved_ondemand = false
  @ondemand = File.expand_path('~/.sauce/ondemand.yml')

  if File.exists?(@ondemand)
    @moved_ondemand = true
    FileUtils.mv(@ondemand, "#{@ondemand}.bak")
  end
end



After do
  if File.exists? PLUGIN_PATH
    FileUtils.rm_f PLUGIN_PATH
  end

  if @moved_ondemand
    FileUtils.mv("#{@ondemand}.bak", @ondemand)
  end
end
