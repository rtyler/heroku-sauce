require 'rspec'

$LOAD_PATH.unshift File.expand_path(File.dirname(__FILE__) + '/../lib')

require 'sauce/heroku/cli'


contexts = File.expand_path(File.dirname(__FILE__) + '/support/contexts')
Dir["#{contexts}/**.rb"].each do |f|
  require f
end
