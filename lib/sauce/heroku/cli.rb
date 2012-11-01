require 'heroku'
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
    end
  end
end
