# frozen_string_literal: true

FactoryBot.define do
  factory :user do
    password { 'password' }

    trait :user_one do
      email { 'john@educative.io' }
    end

    trait :user_two do
      email { 'jane@educative.io' }
    end

    trait :user_three do
      email { 'mike@educative.io' }
    end
  end
end
