require 'spec_helper'

describe Ban do
  let(:ban) { FactoryGirl.create(:ban) }

  subject { ban }

  context 'respond and valid' do
    it { should respond_to(:ban_type_id) }
    it { should respond_to(:reason) }
    it { should respond_to(:until) }
    it { should respond_to(:request_ip) }

    it { should respond_to(:ban_type) }

    it { should be_valid }
  end

  it 'not valid if until time smaller current time' do
    ban.until = Time.now - 1.day
    expect(ban).to be_invalid
  end

  it 'after save cache ip in redis' do
    expect($redis.get("bans:#{ban.ban_type.type}:#{ban.request_ip}")).to eq ban.reason
  end

  it 'after destroy delete ip from redis' do
    expect($redis.get("bans:#{ban.ban_type.type}:#{ban.request_ip}")).to eq ban.reason
    ban.destroy
    expect($redis.get("bans:#{ban.ban_type.type}:#{ban.request_ip}")).to be_nil
  end
end
