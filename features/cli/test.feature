Feature: Test the Sauce connection
  In order to use the Heroku CLI
  As a shell user
  I should be able to verify that my Sauce credentials are correct and that I
  can make API calls through the Heroku CLI


  @wip
  Scenario: Verify the connection with Sauce
    When I run `heroku sauce:help`
    Then the output should contain:
      """
        Hello there!
      """
