# frozen_string_literal: true

FactoryGirl.define do
  factory :repository do
    name Faker::Superhero.name
    last_activity_at Faker::Time.between(10.weeks.ago, Time.zone.today)
  end
end
