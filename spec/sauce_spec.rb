require 'spec_helper'

describe Heroku::Command::Sauce do
  it { should be_instance_of Heroku::Command::Sauce }

  describe '#configured?' do
    let(:exists) { false }

    before :each do
      File.stub(:exists?).with(
          'ondemand.yml').and_return(exists)
      File.stub(:exists?).with(
          File.expand_path('~/.sauce/ondemand.yml')).and_return(exists)
    end


    context 'by default' do
      it { subject.should_not be_configured }
    end

    context 'when configured' do
      let(:exists) { true }

      it { subject.should be_configured }
    end
  end
end
