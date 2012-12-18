require 'spec_helper'

describe Heroku::Command::Sauce do
  let(:command) { subject }
  it { should be_instance_of Heroku::Command::Sauce }

  describe '#scoutup!' do
    context 'when configured' do
      let(:scouturl) { 'http://fakeurl' }
      before :each do
        command.stub(:scout_url).and_return(scouturl)
      end

      it 'should post to Sauce Labs' do
        pending
        HTTParty.should_receive(:post).with(scouturl,
                                            hash_including(:headers => {'Content-Type' => 'application/json'}))
        command.send(:scoutup!)
      end
    end
  end
end
