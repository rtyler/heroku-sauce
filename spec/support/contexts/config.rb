require 'sauce/heroku/config'

shared_context 'valid config' do
  let(:config) do
    config = Sauce::Heroku::Config.new
    config.config = {'username' => 'rspec', 'access_key' => 'rspec'}
    config
  end
end
