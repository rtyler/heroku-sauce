require 'heroku'
require 'heroku/command/base'
require 'httparty'
require 'sauce'
require 'yaml'

module Heroku
  module Command
    class Sauce < BaseWithApp
      attr_accessor :config

      def index
        display 'Lol'
      end

      def help
        display 'Sauce for Heroku Help'
      end

      # sauce:configure
      #
      # Configure the Sauce CLI plugin with your username and API key
      #
      # This command can be used interactively, or all the arguments can be passed on the command line.
      #
      # Interactively: `heroku sauce:configure`
      #
      # CLI options:
      #
      # -u, --user USERNAME  # Your Sauce Labs username
      # -k, --apikey APIKEY  # Your Sauce Labs API key
      def configure
        username = options[:user]
        apikey = options[:apikey]

        if username.nil? && apikey.nil?
          # Let's go interactive!
          display "Sauce username: ", false
          username = ask
          display "Sauce API key: ", false
          apikey = ask
          display ''
        end

        display 'Sauce CLI plugin configured with:'
        display ''
        display "Username: #{username}"
        display "API key : #{apikey}"
        display ''
        display 'If you would like to change this later, update "ondemand.yml" in your current directory'


        File.open('ondemand.yml', 'w+') do |f|
          f.write("""
---
username: #{username}
access_key: #{apikey}
""")
        end
      end

      def chrome
        c = configured?

        unless c
          display 'Sauce for Heroku has not yet been configured!'
        else
          display 'Starting a Chrome session!'
          display scoutup!
        end
      end


      def configured?
        return @config if @config

        if File.exists?('ondemand.yml')
          @config = YAML.load_file('ondemand.yml')
          return @config
        end

        if File.exists?(File.expand_path('~/.sauce/ondemand.yml'))
          @config = YAML.load_file(File.expand_path('~/.sauce/ondemand.yml'))
          return @config
        end

        return false
      end

      def scoutup!
        unless configured?
          display 'The Sauce plugin is not configured properly'
          return
        end

        response = HTTParty.post(scout_url,
                                 :query => JSON.dump({"os" => "Windows 2003",
                                 "browser" => "Firefox",
                                 "browser-version" => "7",
                                 "url" => "http://hello-internet.org
                                 "}),
                                 :headers => {'Content-Type' => 'application/json'})

        return unless (response && response.code == 200)
        return response.body
      end

      private

      def scout_url
        return nil unless configured?
        username = config['username']
        apikey = config['access_key']
        "https://#{username}:#{apikey}@saucelabs.com/rest/v1/users/#{username}/scout"
      end
    end
  end
end
