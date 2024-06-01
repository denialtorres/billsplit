# frozen_string_literal: true

FactoryBot.define do
  factory :group do
    name { 'Test Group' }
  end

  trait :with_users do
    transient do
      users { [create(:user, :user_one), create(:user, :user_two), create(:user, :user_three)] }
    end

    after(:create) do |group, evaluator|
      group.users << evaluator.users
    end
  end
end
