# app/models/insurance_policy.rb
class InsurancePolicy < ApplicationRecord
  belongs_to :user

  enum :status, { pending: 0, active: 1, expired: 2, canceled: 3 }

  validates :policy_number, presence: true, uniqueness: true, format: { with: /\A\d{12}\z/ }

  validates :start_date, :end_date, :status, presence: true

  validates :total_deductible, :total_coverage,
            numericality: { greater_than_or_equal_to: 0 }

  validate :end_date_after_start_date

  private

  def end_date_after_start_date
    return if start_date.blank? || end_date.blank?

    errors.add(:end_date, 'must be after the start date') unless end_date > start_date
  end
end
