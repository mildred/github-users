# frozen_string_literal: true

require 'cucumber/rspec/doubles'

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

When(/^I search an existing github user without repository$/) do
  octokit_user = Sawyer::Resource.new(Octokit.agent, login: Faker::Superhero.name, name: Faker::Superhero.name)
  allow(Octokit).to receive(:user).with(octokit_user.name).and_return(octokit_user)
  allow(Octokit).to receive(:repositories).and_return([])
  within('form') do
    fill_in 'name', with: octokit_user.name
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
  expect(page).to have_css('.repository')
  repositories.split(',').each do |repo|
    expect(page).to have_css('.repository .card-title', text: repo)
  end
end

Then(/^I display a date for github "([^"]*)"$/) do |repositories|
  repositories.split(',').each do |repo|
    infos = repo.split('!')
    expect(page).to have_css('.repository') do |card|
      expect(card).to contain(/#{infos.first}.*#{infos.last}/)
    end
  end
end

Then(/^repositories are ordered by date$/) do
  dates = []
  page.all('.repository .card-text').each do |el|
    dates << Time.zone.parse(el.text)
  end
  expect(dates).to eq dates.sort.reverse
end

Then(/^the repository list is empty$/) do
  expect(page).not_to have_css '.repository'
end

Then(/^an error "([^"]*)" is displayed$/) do |message|
  expect(page).to have_css('.alert.alert-alert')
  expect(page.find('.alert.alert-alert')).to have_content message
end

Then(/^a message "([^"]*)" is displayed$/) do |message|
  expect(page).to have_css('.text-warning', text: message)
end
