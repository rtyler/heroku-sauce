require 'spec_helper'

describe Sauce::Heroku::API::Sauce do
  let(:config) { mock('Sauce::Heroku::Config Mock') }
  # NOTE: The `config` variable is lazily evaluated and the shared context
  # 'valid config' will overwrite the variable to make `api` contain a valid
  # config
  let(:api) { described_class.new(config) }
  subject { api }

  describe '#initialize' do
    context 'with no parameters' do
    end

    context 'with a valid config' do
    end
  end

  describe '#create_scout_session' do
    context 'when passed an empty body' do
      it 'should raise an error' do
        expect {
          api.create_scout_session({})
        }.to raise_error(Sauce::Heroku::Errors::InvalidParametersError)
      end
    end

    context 'when we are not configured' do
      before :each do
        config.stub(:configured? => false)
      end

      it 'should raise an error' do
        expect {
          api.create_scout_session({:foo => :bar})
        }.to raise_error(Sauce::Heroku::Errors::SauceNotConfiguredError)
      end
    end

    context 'when passed a valid body' do
      include_context 'valid config'
      let(:url) { 'http://fake/scout/url' }
      let(:body) { {:url => 'http://saucelabs.com/'} }
      before :each do
        config.stub(:configured? => true)
        api.should_receive(:scout_url).and_return(url)
      end

      it 'should POST to Sauce Labs properly' do
        headers = {'Content-Type' => 'application/json'}
        HTTParty.should_receive(:post).with(url,
                                            hash_including(:headers => headers))
        api.create_scout_session(body)
      end
    end
  end

  describe '#scout_url' do
    subject { api.scout_url }

    context 'when not configured' do
      let(:config) { mock('Mock Config', :configured? => false) }
      before :each do
        api.stub(:config => config)
      end
      it { should be_nil }
    end

    context 'when configured' do
      let(:config) do
        c = mock('Mock Config', :username => 'rspec')
        c.stub(:configured? => true)
        c
      end
      before :each do
        api.stub(:config => config)
      end

      it { should_not be_nil }
      it { should_not be_empty }
    end
  end
end
