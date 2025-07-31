# spec/factories/users.rb
FactoryBot.define do
  factory :user do
    email { Faker::Internet.unique.email }
    password { 'password123' }
    password_confirmation { 'password123' }

    transient do
      role { :client } # padrão
    end

    after(:create) do |user, evaluator|
      user.add_role(evaluator.role)
    end

    trait :admin do
      after(:create) { |user| user.add_role(:admin) }
    end

    trait :operator do
      after(:create) { |user| user.add_role(:operator) }
    end

    trait :client do
      after(:create) { |user| user.add_role(:client) }
    end
  end
end
