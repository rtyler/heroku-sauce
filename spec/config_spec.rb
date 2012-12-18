require 'spec_helper'

describe Sauce::Heroku::Config do
  let(:config) { described_class.new }

  describe '#config' do
    subject { config.config }
    context 'by default' do
      it { should be_nil }
    end
    end

  describe '#configured?' do
    subject { config.configured? }

    context 'by default' do
      it { should_not be_true }
    end

    context 'when a config has been loaded' do
      before :each do
        config.stub(:config => {})
      end

      it { should be_true }
    end
  end

  describe '#load!' do
    subject { config.load! }

    context 'when no config files are available' do
      before :each do
        config.should_receive(:filepath)
      end

      it { should be_nil }
    end

    context 'when a config file is available' do
      let(:fakepath) { '//fake/path/ondemand.yml' }
      let(:contents) { {'config' => true} }

      before :each do
        config.stub(:filepath => fakepath)
        YAML.should_receive(:load_file).with(fakepath).and_return(contents)
      end

      it { should eql(contents) }
    end

    context 'when a config has already been loaded' do
      let(:contents) { {'config' => true} }

      before :each do
        config.stub(:config => contents)
        config.should_receive(:filepath).never
        YAML.should_receive(:load_file).never
      end

      it { should eql(contents) }
    end
  end

  describe '#filepath' do
    subject { config.filepath }

    context 'when no config files exist' do
      before :each do
        File.stub(:exists?).and_return(false)
      end

      it { should be_nil }
    end

    context 'when a local config file exists' do
      let(:expected_path) { File.join(Dir.pwd, Sauce::Heroku::Config::CONFIG_FILE) }

      before :each do
        File.should_receive(:exists?).with(expected_path).and_return(true)
      end

      it { should eql(expected_path) }
    end

    context 'when a user config file exists' do
      let(:expected_path) do
        File.expand_path("~/.sauce/#{Sauce::Heroku::Config::CONFIG_FILE}")
      end

      before :each do
        local_path = File.join(Dir.pwd, Sauce::Heroku::Config::CONFIG_FILE)
        File.should_receive(:exists?).with(local_path).and_return(false)
        File.should_receive(:exists?).with(expected_path).and_return(true)
      end

      it { should eql(expected_path) }
    end
  end

  describe '#username' do
    subject { config.username }

    context 'when not configured' do
      before :each do
        config.stub(:configured? => false)
      end

      it { should be_nil }
    end

    context 'when configured' do
      let(:username) { 'rspec' }
      let(:contents) { {'username' => username } }
      before :each do
        config.stub(:config => contents)
      end

      it { should eql(username) }
    end
  end

  describe '#access_key' do
    subject { config.access_key }

    context 'when not configured' do
      before :each do
        config.stub(:configured? => false)
      end

      it { should be_nil }
    end

    context 'when configured' do
      let(:key) { 'spec-key' }
      let(:contents) { {'access_key' => key } }
      before :each do
        config.stub(:config => contents)
      end

      it { should eql(key) }
    end
  end
end
