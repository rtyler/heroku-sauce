require 'heroku'
require 'heroku/command/base'
require 'httparty'
require 'json'
#require 'sauce'
require 'yaml'

module Heroku
  module Command
    class Sauce < BaseWithApp
      attr_accessor :config

      def index
        display 'Lol'
      end

      # sauce:help
      #
      # Display this help message
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

      # sauce:chrome
      #
      # Start a Sauce Scout session with a Chrome web browser
      def chrome
        c = configured?

        unless c
          display 'Sauce for Heroku has not yet been configured!'
        else
          display 'Starting a Chrome session!'
          display scoutup!
        end
      end

      private

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

        username = config['username']
        apikey = config['access_key']

        response = HTTParty.post(scout_url,
                                 :body => {
                                      :os => "Windows 2003",
                                      :browser => "Firefox",
                                      :'browser-version' => '7',
                                      :url => 'http://hello-internet.org'}.to_json,
                                 :basic_auth => {:username => username,
                                                 :password => apikey},
                                 :headers => {'Content-Type' => 'application/json'})

        return unless (response && response.code == 200)
        response = JSON.parse(response.body)
        if response['embed']
          launchy('Firing up Scout in your browser!', response['embed'])
        end
      end

      def scout_url
        return nil unless configured?
        username = config['username']
        "https://saucelabs.com/rest/v1/users/#{username}/scout"
      end
    end
  end
end
