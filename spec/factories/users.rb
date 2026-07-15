FactoryBot.define do
  factory :user do
    sequence(:name) { |n| "User #{n}" }
    sequence(:email) { |n| "user#{n}_#{SecureRandom.hex(4)}@example.com" }
    password { "password123" }

    trait :admin do
      role { "admin" }
    end

    trait :teacher do
      role { "teacher" }
      sequence(:subject) { |n| "Subject #{n}" }
    end
  end
end