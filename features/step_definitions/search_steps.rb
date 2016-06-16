# frozen_string_literal: true

When(/^I search an unexisting github user$/) do
  within('form') do
    fill_in 'name', with: 'a fake github user'
  end
  click_button 'Search'
end

When(/^I search an existing github "([^"]*)"$/) do |username|
  within('form') do
    fill_in 'name', with: username
  end
  click_button 'Search'
end

Then(/^I have a form to enter a github name$/) do
  expect(page).to have_css('form')
  expect(page.find('form')).to have_css('input[name=name]')
end

Then(/^I can show the "([^"]*)" of the user$/) do |name|
  expect(page.find('h1')).to have_content name
end

Then(/^I display a list of github "([^"]*)"$/) do |repositories|
  expect(page).to have_css('.row .card')
  repositories.split(',').each do |repo|
    expect(page).to have_css('.card-title', text: repo)
  end
end

Then(/^an error "([^"]*)" is displayed$/) do |message|
  expect(page).to have_css('.alert.alert-alert')
  expect(page.find('.alert.alert-alert')).to have_content message
end
