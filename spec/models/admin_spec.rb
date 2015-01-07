require 'spec_helper'

describe Admin do
  let(:admin) { FactoryGirl.create(:admin) }

  subject { admin }

  context 'respond and valid' do
    it { should respond_to(:email) }
    it { should respond_to(:password) }
    it { should respond_to(:password_confirmation) }
    it { should respond_to(:encrypted_password) }
    it { should respond_to(:remember_created_at) }
    it { should respond_to(:sign_in_count) }
    it { should respond_to(:current_sign_in_at) }
    it { should respond_to(:last_sign_in_at) }
    it { should respond_to(:current_sign_in_ip) }
    it { should respond_to(:last_sign_in_ip) }

    it { should be_valid }
  end
end
