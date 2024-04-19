# frozen_string_literal: true

Given('I am on the home page') do
  visit('/home')
end

When('I click on the {string} button') do |button_text|
  click_button(button_text)
end

And(/^I fill in the event creation form with the following data:$/) do |table|
  table.rows_hash.each do |field, value|
    case field
    when 'Event Name'
      fill_in 'EventName', with: value
    when 'Event Venue'
      fill_in 'EventVenue', with: value
    when 'Event Date'
      # Using find and set method to handle date inputs
      find('#EventDate').set(value)
    when 'Event Start Time'
      # Using find and set method for time inputs
      find('#EventStartTime').set(value)
    when 'Event End Time'
      # Using find and set method for time inputs
      find('#EventEndTime').set(value)
    when 'Max Capacity'
      fill_in 'EventMaxCapacity', with: value
    else
      raise "No matching field found for #{field}"
    end
  end
end

And('I submit the event creation form') do
  click_button('Submit')
end

Given('I created an event and I click on the {string} link') do |string|
  click_link(string)
end

Then('I should be on the {string} page') do |string|
  expect(page).to have_content(string)
end

When('I click on {string} event') do |event_name|
  find('div', text: event_name, match: :prefer_exact).click
end

Then('I extract the max capacity of {string}') do |event_name|
  # Find the element containing the Max Capacity and extract the number
  event_div = page.find('div', text: event_name, match: :prefer_exact)
  max_capacity_div = event_div.find('div', text: /Max Capacity:/, match: :first)
  @extracted_max_capacity = max_capacity_div.text.scan(/\d+/).first.to_i
end

And('I count the number of emails sent for the event') do
  email_elements = page.all('p', text: /Email:/)
  @count_emails_sent = email_elements.size
end

Then('the number of emails sent should be less than or equal to the max capacity for the event') do
  expect(@count_emails_sent).to be <= @extracted_max_capacity
end
