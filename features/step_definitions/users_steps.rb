# frozen_string_literal: true

Given(/^there is no users$/) do
end

Given(/^there is some users$/) do
  FactoryGirl.create_list(:user_with_repositories, Faker::Number.between(10, 30))
end

Then(/^I see a list of all users$/) do
  User.all do |user|
    expect(page).to have_css('.user') do |el|
      expect(el).to contain(user.name)
      expect(el).to contain("#{user.repositories.count} repositories")
    end
  end
end

Then(/^the list is ordered by name$/) do
  ref = User.all.order(:name).map(&:name)
  names = []
  page.all('.user .card-title').each do |el|
    names << el.text
  end
  expect(names).to eq ref
end
