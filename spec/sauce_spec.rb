require 'spec_helper'

describe Heroku::Command::Sauce do
  let(:command) { described_class.new }

  describe '#scoutup!' do
    context 'when configured' do
      let(:config) do
        c = mock('Sauce::Heroku::Config Mock')
        c.stub(:configured? => true)
        c.stub(:username => 'rspec')
        c.stub(:access_key => 'rspec')
        c
      end

      let(:scouturl) { 'http://fakeurl' }

      before :each do
        command.stub(:scout_url).and_return(scouturl)
        command.instance_variable_set(:@config, config)
      end

      it 'should post to Sauce Labs' do
        HTTParty.should_receive(:post).with(scouturl,
                                            hash_including(:headers => {'Content-Type' => 'application/json'}))
        command.send(:scoutup!)
      end
    end
  end

  describe '#scout_url' do
    subject { command.send(:scout_url) }

    context 'when not configured' do
      let(:config) { mock('Mock Config', :configured? => false) }
      before :each do
        command.instance_variable_set(:@config, config)
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
        command.instance_variable_set(:@config, config)
      end

      it { should_not be_nil }
      it { should_not be_empty }
    end
  end
end
