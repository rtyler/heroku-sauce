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
end



After do
  if File.exists? PLUGIN_PATH
    FileUtils.rm_f PLUGIN_PATH
  end
end
