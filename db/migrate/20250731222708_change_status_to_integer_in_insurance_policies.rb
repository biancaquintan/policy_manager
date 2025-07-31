class ChangeStatusToIntegerInInsurancePolicies < ActiveRecord::Migration[7.1]
  def up
    change_column :insurance_policies, :status, :integer, using: 'status::integer', default: 0, null: false
  end

  def down
    change_column :insurance_policies, :status, :string, using: 'status::text', default: nil, null: true
  end
end
