FactoryGirl.define do
  factory :student do
    grade :A
    sequence(:email) { |n| "student#{n}@email.com" }

    sequence(:first_name) { |n| "Henderleigh-#{n}" }
    sequence(:last_name) { |n| ["McNabb", "Trufflestein", "Kombucha", "Cookbook"].sample }

    school_grade(10)

    priority { rand(30) }
    parent { create(:parent) }
  end
end
