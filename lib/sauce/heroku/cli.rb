require 'heroku'
require 'heroku/command/base'
require 'httparty'
require 'json'
#require 'sauce'
require 'yaml'

module Heroku
  module Command
    class Sauce < BaseWithApp
      def index
        display 'Please run `heroku help sauce` for more details'
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

      [
        #[:chrome, ['Windows 2008', 'chrome', '']],
        [:firefox4, ['Windows 2003', 'firefox', '4']],
        [:firefox, ['Windows 2003', 'firefox', '17']],

        [:android, ['Linux', 'android', '4']],

        [:iphone, ['Mac 10.8', 'iphone', '6']],
        [:safari, ['Mac 10.6', 'safari', '5']],

        [:ie6, ['Windows 2003', 'iexplore', '6']],
        [:ie7, ['Windows 2003', 'iexplore', '7']],
        [:ie8, ['Windows 2003', 'iexplore', '8']],
        [:ie9, ['Windows 2008', 'iexplore', '9']],
      ].each do |method, args|
        define_method(method) do
          unless configured?
            display 'Sauce for Heroku has not yet been configured!'
          else
            @url = api.get_app(app).body['web_url']

            unless @url
              display 'Unable to get the URL for your app, bailing out!'
              return
            end

            @os, @browser, @browserversion = args
            display "Starting a #{@browser} session on #{@os}!"
            unless scoutup!
              display 'Failed to fire up a Scout session for some reason'
            end
          end

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

        body = {:os => @os,
                :browser => @browser,
                :'browser-version' => @browserversion,
                :url => @url}

        response = HTTParty.post(scout_url,
                                 :body => body.to_json,
                                 :basic_auth => {:username => username,
                                                 :password => access_key},
                                 :headers => {'Content-Type' => 'application/json'})

        return false unless (response && response.code == 200)

        response = JSON.parse(response.body)

        if response['embed']
          launchy('Firing up Scout in your browser!', response['embed'])
        end

        return true
      end

      def scout_url
        return nil unless configured?
        "https://saucelabs.com/rest/v1/users/#{username}/scout"
      end

      def username
        return unless configured?
        @config['username']
      end

      def access_key
        return unless configured?
        @config['access_key']
      end
    end
  end
end
