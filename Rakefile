require 'rspec/core/rake_task'
require 'cucumber/rake/task'


RSpec::Core::RakeTask.new('spec') do |t|
  t.rspec_opts = '--color --fail-fast --order random'
end

Cucumber::Rake::Task.new('cucumber')


BUNDLER_VARS = %w(BUNDLE_GEMFILE RUBYOPT GEM_HOME)
  def with_clean_env
    begin
      bundled_env = ENV.to_hash
      BUNDLER_VARS.each{ |var| ENV.delete(var) }
      yield
    ensure
      ENV.replace(bundled_env.to_hash)
    end
  end

namespace :gems do
  desc 'Vendor the gems in Gemfile.deploy'
  task :vendor do
    with_clean_env do
      sh 'bundle install --deployment --standalone=vendor --gemfile=Gemfile.deploy --path=vendor'
      sh 'bundle install --no-deployment'
    end
  end
end

task :default => [:spec, :cucumber]
