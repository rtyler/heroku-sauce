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
        return nil if filepath.nil?

        @config = YAML.load_file(filepath)
      end

      def configured?
        return !(config.nil?)
      end

      def username
        return nil unless configured?
        config['username']
      end

      def access_key
        return nil unless configured?
        config['access_key']
      end

      def write!
        if username.nil? || access_key.nil?
          return nil
        end
      end
    end
  end
end
