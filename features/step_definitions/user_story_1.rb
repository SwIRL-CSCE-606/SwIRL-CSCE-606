Given(/^I am on the Main Page$/) do
  visit root_path
end

When(/^I click on the Organizer Button$/) do
  click_link 'Event Page'
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


Then('I fill in the following details:') do |table|
  # table is a Cucumber::MultilineArgument::DataTable
  pending # Write code here that turns the phrase above into concrete actions
end

Then('I click on the Submit Button') do
  pending # Write code here that turns the phrase above into concrete actions
end

Then('I should be on the People List Page') do
  pending # Write code here that turns the phrase above into concrete actions
end

Given('I am on the People List Page for Test Event') do
  pending # Write code here that turns the phrase above into concrete actions
end

When('I add the following individuals with accommodations:') do |table|
  # table is a Cucumber::MultilineArgument::DataTable
  pending # Write code here that turns the phrase above into concrete actions
end

When('I click on the Submit Button') do
  pending # Write code here that turns the phrase above into concrete actions
end

Then('I should see a confirmation message') do
  pending # Write code here that turns the phrase above into concrete actions
end

Then('the event details should be saved in the database') do
  pending # Write code here that turns the phrase above into concrete actions
end