FactoryBot.define do
  sequence :answer_body do |n|
    "Answers body #{n}"
  end

  factory :answer do
    body { generate(:answer_body) }

    trait :invalid do
      body { nil }
    end
  end
end
