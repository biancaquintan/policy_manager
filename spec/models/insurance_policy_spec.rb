require 'rails_helper'

RSpec.describe InsurancePolicy, type: :model do
  describe 'Associations' do
    it { is_expected.to belong_to(:user) }
  end

  describe 'Validations' do
    subject { build(:insurance_policy, :with_fixed_policy_number) }

    before do
      create(:insurance_policy, :with_fixed_policy_number)
    end

    it { is_expected.to validate_presence_of(:policy_number) }
    it { is_expected.to validate_uniqueness_of(:policy_number).case_insensitive }

    it { is_expected.to allow_value('123456789012').for(:policy_number) }
    it { is_expected.not_to allow_value('abc').for(:policy_number) }

    it { is_expected.to validate_presence_of(:start_date) }
    it { is_expected.to validate_presence_of(:end_date) }

    it { is_expected.to validate_numericality_of(:total_deductible).is_greater_than_or_equal_to(0) }
    it { is_expected.to validate_numericality_of(:total_coverage).is_greater_than_or_equal_to(0) }
  end

  describe 'Enum :status' do
    subject(:insurance_policy) { build(:insurance_policy) }

    it {
      expect(insurance_policy).to define_enum_for(:status)
        .with_values(%i[pending active expired canceled])
    }
  end

  describe 'Date validations' do
    subject(:policy) { build(:insurance_policy, start_date: start_date, end_date: end_date) }

    let(:start_date) { Time.zone.today }
    let(:end_date) { Date.yesterday }

    context 'when end_date is before start_date' do
      it 'is invalid' do
        expect(policy).not_to be_valid
      end

      it 'add end_date error' do
        policy.validate
        expect(policy.errors[:end_date]).to include('must be after the start date')
      end
    end
  end
end
