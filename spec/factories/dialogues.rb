FactoryBot.define do
  factory :dialogue do
    association :sender, factory: :user
    association :recipient, factory: :user
  end
end