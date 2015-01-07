require 'spec_helper'

describe BanType do
  let(:ban_type) { FactoryGirl.create(:ban_type) }
  let(:ban) { FactoryGirl.create(:ban) }

  subject { ban_type }

  context 'respond and valid' do
    it { should respond_to(:type) }

    it { should respond_to(:bans) }

    it { should be_valid }
  end

  it 'destroy all related bans after destroy' do
    ban.ban_type.destroy
    expect{ Ban.find(ban) }.to raise_error(Mongoid::Errors::DocumentNotFound)
  end
end
