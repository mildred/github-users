# frozen_string_literal: true

Then(/^I have a form to enter a github name$/) do
  expect(page).to have_css('form')
  expect(page.find('form')).to have_css('input[name=name]')
end
