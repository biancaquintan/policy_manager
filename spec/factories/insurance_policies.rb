# spec/factories/insurance_policies.rb
FactoryBot.define do
  factory :insurance_policy do
    policy_number { Faker::Number.unique.number(digits: 12).to_s }
    start_date { Faker::Date.backward(days: 30) }
    end_date { Faker::Date.forward(days: 30) }
    status { InsurancePolicy.statuses.keys.sample.to_sym }
    total_deductible { Faker::Number.decimal(l_digits: 3, r_digits: 2) }
    total_coverage { Faker::Number.decimal(l_digits: 5, r_digits: 2) }
    association :user

    trait :with_fixed_policy_number do
      policy_number { '121416182022' }
    end
  end
end
