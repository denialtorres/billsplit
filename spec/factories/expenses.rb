FactoryBot.define do
  factory :expense do
    amount { 1.5 }
    user { nil }
    group { nil }
  end
end
