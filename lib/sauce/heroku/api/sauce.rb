require 'httparty'
require 'json'

module Sauce
  module Heroku
    module API
      class Sauce
        attr_reader :config

        API_CLIENT_ID = '0C309258-40FA-4138-91AF-C226F17C6954'

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
                                  :headers => default_headers)

          if response.code == 401
            raise Errors::SauceAuthenticationError, 'Authentication failed'
          elsif response.code != 200
            raise Errors::SauceUnknownError, 'Something is wrong with the Sauce Labs API'
          end

          begin
            response = JSON.parse(response.body)
          rescue JSON::ParserError
            raise Errors::SauceUnknownError, 'Sauce API is returning invalid JSON'
          end

          # The response should contain the attribute `embed` which is the
          # usable scout session URL
          return response['embed']
        end

        def default_headers
          @headers ||= begin
                {
                  'Content-Type' => 'application/json'
                }
          end
        end

        def scout_url
          return nil unless config.configured?
          "https://saucelabs.com/rest/v1/users/#{config.username}/scout"
        end

        def create_account(username, password, email, full_name)
          if username.nil? || email.nil? || password.nil?
            raise Errors::InvalidParametersError
          end
          full_name ||= ''
          data = {:username => username,
                  :email => email,
                  :password => password,
                  :name => full_name,
                  :token => API_CLIENT_ID}

          response = HTTParty.post(account_url,
                                   :body => data.to_json,
                                   :headers => default_headers)
        end
      end
    end
  end
end
