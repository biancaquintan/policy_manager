# app/policies/insurance_policy_policy.rb
class InsurancePolicyPolicy < ApplicationPolicy
  # Controla o acesso às apólices conforme role do usuário
  class Scope < ApplicationPolicy::Scope
    def resolve
      if user.has_role?(:admin) || user.has_role?(:operator)
        scope.all
      else
        scope.where(user_id: user.id)
      end
    end
  end

  def index?
    user.has_role?(:admin) || user.has_role?(:operator)
  end

  def show?
    user.has_role?(:admin) || user.has_role?(:operator) || owns_record?
  end

  def create?
    user.has_role?(:admin) || user.has_role?(:operator)
  end

  def assign_user_id?
    create?
  end

  def update?
    user.has_role?(:admin)
  end

  def destroy?
    user.has_role?(:admin)
  end

  private

  def owns_record?
    record.user_id == user.id
  end
end
