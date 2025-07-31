require 'rails_helper'

# spec/models/user_spec.rb
RSpec.describe User, type: :model do
  describe 'Associations' do
    it { is_expected.to have_many(:insurance_policies).dependent(:destroy) }
  end

  describe 'Devise validations' do
    subject { build(:user) }

    it { is_expected.to validate_presence_of(:email) }
    it { is_expected.to validate_uniqueness_of(:email).case_insensitive }

    it { is_expected.to validate_length_of(:password).is_at_least(6) }
  end

  describe 'Role assignment' do
    context 'when user is client' do
      let(:user) { create(:user, role: :client) }

      it 'has role :client' do
        expect(user.has_role?(:client)).to be true
      end
    end

    context 'when user is admin' do
      let(:user) { create(:user, role: :admin) }

      it 'has role :admin' do
        expect(user.has_role?(:admin)).to be true
      end
    end

    context 'when user is operator' do
      let(:user) { create(:user, role: :operator) }

      it 'has role :operator' do
        expect(user.has_role?(:operator)).to be true
      end
    end
  end
end
