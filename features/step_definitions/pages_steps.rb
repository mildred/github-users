# frozen_string_literal: true

Given(/^I am on the root page$/) do
  visit root_path
end

When(/^I am on the users page$/) do
  visit users_path
end
