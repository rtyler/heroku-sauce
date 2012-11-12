
module SauceConfiguration
  def config
    {:username => 'tester', :access_key => 'testkey'}
  end

  def dump_config!
    in_current_dir do
      File.open('ondemand.yml', 'w+') do |f|
        f.write(config.to_yaml)
      end
    end
  end
end

World(SauceConfiguration)
