class CreateInsurancePolicies < ActiveRecord::Migration[7.1]
  def change
    create_table :insurance_policies do |t|
      t.string :policy_number, null: false
      t.date :start_date
      t.date :end_date
      t.string :status
      t.decimal :total_deductible, precision: 10, scale: 2
      t.decimal :total_coverage, precision: 15, scale: 2
      t.references :user, null: false, foreign_key: true

      t.timestamps
    end

    add_index :insurance_policies, :policy_number, unique: true
  end
end
