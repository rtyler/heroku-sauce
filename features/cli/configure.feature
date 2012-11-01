Feature: Configure the Sauce credentials
  In order to get started quickly with the Sauce Heroku CLI
  As a heroku user
  I should be able to configure my Sauce credentials through the CLI plugin


  Scenario: Display configure help
    When I run `heroku sauce:configure -h`
    Then the output should contain:
      """
      Usage: heroku sauce:configure

       Configure the Sauce CLI plugin with your username and API key

       This command can be used interactively, or all the arguments can be passed on the command line.

       Interactively: `heroku sauce:configure`

       CLI options:

       -u, --user USERNAME  # Your Sauce Labs username
       -k, --apikey APIKEY  # Your Sauce Labs API key
      """

    Scenario: Interactive configuration
      When I run `heroku sauce:configure` interactively
      And I type "cucumber"
      And I type "cucumberapikey"
      Then the output should contain:
        """
        Sauce CLI plugin configured with:

        Username: cucumber
        API key : cucumberapikey

        If you would like to change this later, update "ondemand.yml" in your current directory
        """
        And a file named "ondemand.yml" should exist


    @wip
    Scenario: Interactive configuration without valueis
      When I run `heroku sauce:configure` interactively
      And I type ""
      And I type ""
      Then the output should contain:
        """
        Whoops! I think you forgot to give me a valid username and API key
        """

