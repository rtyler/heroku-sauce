module Sauce
  module Heroku
    module Errors
      class SauceAuthenticationError < StandardError; end;
      class InvalidParametersError < StandardError; end;
      class SauceNotConfiguredError < StandardError; end;
      class SauceUnknownError < StandardError; end;
    end
  end
end
