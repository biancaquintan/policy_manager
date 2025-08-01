require 'rails_helper'

RSpec.describe InsurancePolicyPolicy, type: :policy do
  subject(:policy_class) { described_class }

  let(:admin) { create(:user, :admin) }
  let(:operator) { create(:user, :operator) }
  let(:client) { create(:user, :client) }

  let(:own_policy) { create(:insurance_policy, user: client) }
  let(:other_policy) { create(:insurance_policy) }

  describe '#index?' do
    it 'permite admin' do
      expect(policy_class.new(admin, InsurancePolicy).index?).to be true
    end

    it 'permite operator' do
      expect(policy_class.new(operator, InsurancePolicy).index?).to be true
    end

    it 'nega client' do
      expect(policy_class.new(client, InsurancePolicy).index?).to be false
    end
  end

  describe '#create?' do
    it 'permite admin' do
      expect(policy_class.new(admin, InsurancePolicy).create?).to be true
    end

    it 'permite operator' do
      expect(policy_class.new(operator, InsurancePolicy).create?).to be true
    end

    it 'nega client' do
      expect(policy_class.new(client, InsurancePolicy).create?).to be false
    end
  end

  describe '#show?' do
    it 'permite admin para qualquer apólice' do
      expect(policy_class.new(admin, other_policy).show?).to be true
    end

    it 'permite operator para qualquer apólice' do
      expect(policy_class.new(operator, other_policy).show?).to be true
    end

    it 'permite client para sua própria apólice' do
      expect(policy_class.new(client, own_policy).show?).to be true
    end

    it 'nega client para apólice de outro usuário' do
      expect(policy_class.new(client, other_policy).show?).to be false
    end
  end

  describe '#update?' do
    it 'permite admin para sua apólice' do
      expect(policy_class.new(admin, own_policy).update?).to be true
    end

    it 'permite admin para apólice de outro usuário' do
      expect(policy_class.new(admin, other_policy).update?).to be true
    end

    it 'nega operator para apólice de outro usuário' do
      expect(policy_class.new(operator, other_policy).update?).to be false
    end

    it 'nega client para sua apólice' do
      expect(policy_class.new(client, own_policy).update?).to be false
    end
  end

  describe '#destroy?' do
    it 'permite admin para sua apólice' do
      expect(policy_class.new(admin, own_policy).destroy?).to be true
    end

    it 'permite admin para apólice de outro usuário' do
      expect(policy_class.new(admin, other_policy).destroy?).to be true
    end

    it 'nega operator para apólice de outro usuário' do
      expect(policy_class.new(operator, other_policy).destroy?).to be false
    end

    it 'nega client para sua apólice' do
      expect(policy_class.new(client, own_policy).destroy?).to be false
    end
  end
end
