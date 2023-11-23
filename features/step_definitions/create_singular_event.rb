Given('the user is on the home page') do
  visit('/home') # Adjust this as per your actual home page URL
end

When('the user clicks on {string} button') do |button_text|
  click_button(button_text)
end

And(/^the user fills in the event creation form with the following data:$/) do |table|
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

And('the user submits the event creation form') do
  click_button('Submit') # Adjust this if your submit button has a different name or text
end

Then('the user should be redirected to the event details page with a unique event ID') do
  expect(page).to have_content('Event was successfully created.') # Change this text as per your app's confirmation message
  url = URI.parse(current_url).path
  @event_id = url.split('/').last
end

And('the user should see the following event details:') do |table|
  table.rows_hash.each do |_field, value|
    expect(page).to have_content(value)
  end
end

When('the user clicks the "Status" button') do
  click_link('Status') # Replace with the actual text or ID of the Status button/link
end

Then('the user should see the event {string} listed with its details') do |event_name|
  expect(page).to have_content(event_name)
end

When('the user clicks on the event named {string}') do |event_name|
  # Click the event header to toggle the event content visibility
  find('.event-header', text: event_name).click
end

Then(/^the event content for "([^"]*)" should be visible$/) do |event_name|
  # Get the event ID from the onclick attribute in the event header
  event_id = find('.event-header', text: event_name)[:onclick].match(/toggleEventContent\('(\d+)'\)/)[1]

  # Check that the event content is visible using the correct ID
  expect(page).to have_css("#event-content-#{event_id}", visible: true)
end

Then('the event {string} should display the following details:') do |event_name, table|
  event_id = find('.event-header', text: event_name)[:onclick].match(/toggleEventContent\('(\d+)'\)/)[1]
  event_details = find("#event-content-#{event_id}", visible: true)

  table.rows_hash.each do |_field, value|
    within(event_details) do
      expect(page).to have_content(value)
    end
  end
end
