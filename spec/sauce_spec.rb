require 'spec_helper'

describe Heroku::Command::Sauce do
  let(:command) { described_class.new }

  describe '#scoutup!' do
    context 'when configured' do
      it 'should create a scout session' do
        api = command.instance_variable_get(:@sauceapi)
        api.should_receive(:create_scout_session)
        command.send(:scoutup!)
      end
    end
  end
end
