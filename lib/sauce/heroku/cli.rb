require 'heroku'
require 'heroku/command/base'

require 'sauce/heroku/api'
require 'sauce/heroku/config'
require 'sauce/heroku/errors'

module Heroku
  module Command
    class Sauce < BaseWithApp
      def initialize(*args)
        super(*args)
        @config = ::Sauce::Heroku::Config.new
        @config.load!
        @sauceapi = ::Sauce::Heroku::API::Sauce.new(@config)
      end

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
          unless @config.configured?
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


      def scoutup!
        unless @config.configured?
          display 'The Sauce plugin is not configured properly'
          return
        end

        body = {:os => @os,
                :browser => @browser,
                :'browser-version' => @browserversion,
                :url => @url}


        url = nil
        begin
          url = @sauceapi.create_scout_session(body)
        rescue ::Sauce::Heroku::Errors::SauceAuthenticationError
          puts 'Auth error!'
        end

        unless url.nil?
          launchy('Firing up Scout in your browser!', url)
        end
      end
    end
  end
end
