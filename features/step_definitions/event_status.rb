Given('I visit the event status page') do
    visit eventsList_path
end

Then('I should see the details of the events') do
  expect(page).to have_css('.event-card')
end

Then('I should see the list of attendees for each event') do
  expect(page).to have_css('.attendee')
end

Then(/I should see "(.*?)" as an event name/) do |event_name|
  expect(page).to have_content(event_name)
end

Then(/I should see "(.*?)" as the event description/) do |description|
  expect(page).to have_content(description)
end

Then(/I should see "(.*?)" as the event location/) do |location|
  expect(page).to have_content(location)
end

Then(/I should see "(.*?)" and "(.*?)" as the invite status for "(.*?)"$/) do |yes_count, no_count, event_name|
  within('.event-card', text: event_name) do
    expect(page).to have_content(yes_count)
    expect(page).to have_content(no_count)
  end
end

Then("I should see {string} with status {string} in the attendees list") do |name, status|
    within(first('.event-card')) do
      attendee_element = find('.attendee', text: name)
      expect(attendee_element).to have_content(status)
    end
  end
  
  
  
