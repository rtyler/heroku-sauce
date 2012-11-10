require 'heroku'
require 'heroku/command/base'
require 'sauce'

module Heroku
  module Command
    class Sauce < BaseWithApp
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
        display 'Sauce for Heroku has not yet been configured!'
      end
    end
  end
end
