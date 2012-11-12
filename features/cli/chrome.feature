Feature: Start a chrome browser pointing at my Heroku site
  In order to test my website in the Chrome browser
  As a Heroku user
  I should be able to fire up a Sauce Scout instance pointing at my Heroku
  instance


  Scenario: Without having configured Sauce
    Given I haven't already configured the plugin
    When I run `heroku sauce:chrome`
    Then the output should contain:
      """
      Sauce for Heroku has not yet been configured!
      """

  Scenario: With Sauce configured
    Given I have configured the plugin
    When I run `heroku sauce:chrome`
    Then the output should contain:
      """
      Starting a Chrome session!
      """
