Feature: Display help information


  Scenario: Display help
    When I run `heroku sauce:help`
    Then the output should contain:
      """
      Sauce for Heroku Help
      """
