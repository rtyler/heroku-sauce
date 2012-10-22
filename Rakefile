require 'rspec/core/rake_task'
require 'cucumber/rake/task'


RSpec::Core::RakeTask.new('spec') do |t|
  t.rspec_opts = '--color --fail-fast --order random'
end

Cucumber::Rake::Task.new('cucumber')
