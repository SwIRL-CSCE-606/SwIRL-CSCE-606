Given(/^I am on the Main Page$/) do
  visit root_path
end

When(/^I click on the Organizer Button$/) do
  click_link 'Organizer'
end

Then(/^I should be on the Organizer Page$/) do
  expect(current_path).to eq home_path
end

Then(/^I should see options for Singular Event, Repeating Event, and Current Status$/) do
  expect(page).to have_text('Create singular event')
  expect(page).to have_text('Create series event')
  expect(page).to have_text('Check current status')
end

Given('I am on the Organizer Page') do
  visit home_path
end

When('I click on Create singular event') do
  click_link 'Create singular event'
end

Then("I should be on the Singular Event Creation Page") do
  expect(page).to have_current_path newEvents_path
end

