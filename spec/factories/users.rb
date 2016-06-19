# frozen_string_literal: true

FactoryGirl.define do
  factory :user do
    login Faker::Superhero.name
    name Faker::Superhero.name
    followers Faker::Number.between(1, 1000)
    repositories []

    factory :user_with_repositories do
      transient do
        repo_count Faker::Number.between(1, 10)
      end

      after(:create) do |user, evaluator|
        create_list(:repository, evaluator.repo_count, user: user)
      end
    end
  end
end
