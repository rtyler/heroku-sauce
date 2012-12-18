require 'yaml'

module Sauce
  module Heroku
    class Config
      CONFIG_FILE = 'ondemand.yml'

      attr_accessor :config

      def filepath
        [
          File.join(Dir.pwd, CONFIG_FILE),
          File.expand_path("~/.sauce/#{CONFIG_FILE}")
        ].each do |path|
          if File.exists?(path)
            return path
          end
        end
        return nil
      end

      def load!
        return config unless config.nil?

        if filepath.nil?
          return nil
        end

        config = YAML.load_file(filepath)
      end

      def configured?
        return !(config.nil?)
      end
    end
  end
end
