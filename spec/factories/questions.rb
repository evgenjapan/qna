FactoryBot.define do
  sequence :title do |n|
    "Question №#{n}"
  end

  sequence :body do |n|
    "Question body #{n}"
  end

  factory :question do
    title
    body
    user { nil }

    trait :invalid do
      title { nil }
    end
  end
end
