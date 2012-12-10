# Heroku + Sauce = ♡

[![Build
Status](https://buildhive.cloudbees.com/job/rtyler/job/heroku-sauce/badge/icon)](https://buildhive.cloudbees.com/job/rtyler/job/heroku-sauce/)

An experimental plugin for the Heroku CLI to hook it up to Sauce Labs.


## Using

To install the Sauce for Heroku plugin, run the following command:

    % heroku plugins:install git://github.com/rtyler/heroku-sauce.git

After the plugin has been successfully installed, the `heroku help sauce`
command should list a number of available subcommands:

    % heroku help sauce
    Usage: heroku sauce


    Additional commands, type "heroku help COMMAND" for more details:

    sauce:android    # 
    sauce:configure  #  Configure the Sauce CLI plugin with your username and API key
    sauce:firefox    # 
    sauce:firefox4   # 
    sauce:ie6        # 
    sauce:ie7        # 
    sauce:ie8        # 
    sauce:ie9        # 
    sauce:iphone     # 
    sauce:safari     # 

    %


Currently Sauce for Heroku cannot do any auto-detection of a Sauce Labs
account. If you do not have a Sauce Labs account, you can [register
here](https://saucelabs.com/signup/plan/free).


Once you have an account, use the following command to configure Heroku for
Sauce:

    % heroku sauce:configure
    Sauce username: <enter here>
    Sauce API key: <copy/paste here>

    Sauce CLI plugin configured with:

    Username: example
    API key : example-api-key

    If you would like to change this later, update "ondemand.yml" in your current directory
    %


Hooray! Sauce for Heroku is now configured! Running one of the other commands,
such as `heroku sauce:firefox` will open your browser with a Firefox browser
running on Sauce, hitting your Heroku app.

Happy testing!
