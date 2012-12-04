require 'spec_helper'

describe Heroku::Command::Sauce do
  let(:command) { subject }
  it { should be_instance_of Heroku::Command::Sauce }

  describe '#configured?' do
    let(:exists) { false }

    context 'by default' do
      before :each do
        File.stub(:exists?).with(
            'ondemand.yml').and_return(false)
        File.stub(:exists?).with(
            File.expand_path('~/.sauce/ondemand.yml')).and_return(false)
      end

      it { command.should_not be_configured }
    end

    context 'configured with a local ondemand.yml' do
      let(:config) do
        {
          'username' => 'niceguy',
          'access_key' => 'sekret'
        }
      end

      before :each do
        File.should_receive(:exists?).with('ondemand.yml').and_return(true)
        YAML.should_receive(:load_file).with('ondemand.yml').and_return(config)
      end

      it { command.should be_configured }
      it 'should return the configuration' do
        result = command.configured?

        result.should be_instance_of(Hash)
        expect(result['username']).to eql(config['username'])
        expect(result['access_key']).to eql(config['access_key'])
      end
    end
  end


  describe '#scoutup!' do
    it { should respond_to :scoutup! }

    context 'when configured' do
      let(:scouturl) { 'http://fakeurl' }
      before :each do
        command.should_receive(:configured?).and_return(true)
        command.stub(:scout_url).and_return(scouturl)
      end

      it 'should post to Sauce Labs' do
        HTTParty.should_receive(:post).with(scouturl,
                                            hash_including(:headers => {'Content-Type' => 'application/json'}))
        command.scoutup!
      end
    end
  end
end
