require 'spec_helper'

describe Heroku::Command::Sauce do
  it { should be_instance_of Heroku::Command::Sauce }

  describe '#configured?' do
    let(:exists) { false }

    before :each do
    end


    context 'by default' do
      before :each do
        File.stub(:exists?).with(
            'ondemand.yml').and_return(false)
        File.stub(:exists?).with(
            File.expand_path('~/.sauce/ondemand.yml')).and_return(false)
      end

      it { subject.should_not be_configured }
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

      it { subject.should be_configured }
      it 'should return the configuration' do
        result = subject.configured?

        result.should be_instance_of(Hash)
        expect(result['username']).to eql(config['username'])
        expect(result['access_key']).to eql(config['access_key'])
      end
    end
  end
end
