Given /^I haven't already configured the plugin$/ do
  # no op
end

Given /^I have configured the plugin$/ do
  dump_config!
end

