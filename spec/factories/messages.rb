FactoryBot.define do
  factory :message do
    body { "Sample message text" }
    association :user
    association :dialogue
  end
end
