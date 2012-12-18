require 'httparty'
require 'json'

module Sauce
  module Heroku
    module API
      class Sauce
        attr_reader :config

        def initialize(config)
          @config = config
        end

        def create_scout_session(body)
          if body.nil? || body.empty?
            raise Errors::InvalidParametersError, 'body cannot be empty!'
          end

          unless config.configured?
            raise Errors::SauceNotConfiguredError, 'we do not have a valid config loaded'
          end

          response = HTTParty.post(scout_url,
                                  :body => body.to_json,
                                  :basic_auth => {:username => config.username,
                                                  :password => config.access_key},
                                  :headers => {'Content-Type' => 'application/json'})

          return nil unless (response && response.code == 200)

          response = JSON.parse(response.body)
          # The response should contain the attribute `embed` which is the
          # usable scout session URL
          return response['embed']
        end

        def scout_url
          return nil unless config.configured?
          "https://saucelabs.com/rest/v1/users/#{config.username}/scout"
        end
      end
    end
  end
end
