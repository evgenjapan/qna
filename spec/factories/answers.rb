FactoryBot.define do
  sequence :answer_body do |n|
    "Answers body #{n}"
  end

  factory :answer do
    body { generate(:answer_body) }
    user
    question

    trait :invalid do
      body { nil }
    end

    trait :best do
      best { true }
    end
  end
end
