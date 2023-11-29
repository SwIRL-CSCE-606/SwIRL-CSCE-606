Given('the user is on the series event page') do
  visit('/series') # Path for the series event page
end

When('the user fills in the series event form with the following details:') do |table|
  data = table.rows_hash
  fill_in 'Event Name', with: data['Event Name']
  fill_in 'Event Venue', with: data['Event Venue']
  fill_in 'event[time_slot][][date]', with: data['Date']
  fill_in 'event[time_slot][][start_time]', with: data['Start Time']
  fill_in 'event[time_slot][][end_time]', with: data['End Time']
end

# When('the user adds two date-time pairs') do
#   2.times { find_button('add-date-time').click }

#   # Wait for the specific number of date-time pairs to appear

#   # expect(page).to have_selector('.date-time-pair', count: 2, wait: 5)

#   # Now find all elements with the class '.date-time-pair'
#   date_time_pairs = all('.date-time-pair')

#   # Debug: Output the number of date-time pairs found
#   puts "Date-time pairs found: #{date_time_pairs.size}"

#   # Iterate over the found date-time pairs
#   date_time_pairs.each_with_index do |pair, index|
#     within(pair) do
#       # Assuming the date and time fields can be identified without relying on unique IDs
#       fill_in 'event[time_slot][][date]', with: (Date.today + 1).strftime('%Y-%m-%d')
#       fill_in 'event[time_slot][][start_time]', with: '09:00'
#       fill_in 'event[time_slot][][end_time]', with: '17:00'
#     end
#   end
# end

# When('the user removes the last date-time pair') do
#   # Assuming you have a 'Remove' button for each date-time pair
#   all('.remove-date-time').last.click
# end

And('the user submits the series event form') do
  date_times = all('.date-time-pair')
  raise 'No date-time pairs found' if date_times.empty?

  date_times.each do |pair|
    date_field = pair.find('.form-input[type="date"]')
    start_time_field = pair.find('.form-input[type="time"]', match: :first)
    end_time_field = pair.find('.form-input[type="time"]', match: :prefer_exact)

    if date_field.value.empty? || start_time_field.value.empty? || end_time_field.value.empty?
      raise 'Date and Time fields cannot be empty'
    end
  end

  click_button('Submit')
end

Then('the user should see the following series event details:') do |table|
  table.rows_hash.each do |field, value|
    expect(page).to have_content(value)
  end
end


# Then('the user should see a confirmation that the series event was created') do
#   # Adjust the expected text to match what your application will show as a confirmation message
#   expect(page).to have_content('Series event was successfully created')
# end

When('the user uploads a csv file') do
  # Assuming 'path_to_csv' is the path to your CSV file

  path_to_csv = './features/step_definitions/files/Test.csv'
  attach_file('event[csv_file]', path_to_csv) # 'Choose File' is the name of the input field for file upload
end

And('the event {string} should display the following attendee details:') do |event_name, attendees_table|
  # Find and click the event card to reveal the event content
  find('.event-card', text: event_name).click

  # Now check the attendee details within the event content
  attendees_table.hashes.each do |attendee|
    within('.event-content', visible: true) do
      attendee_li = find('.attendee', text: attendee['Email'])
      expect(attendee_li).to have_text("Email: #{attendee['Email']}")
      status_span = attendee_li.find('span.status')
      expect(status_span.text).to eq(attendee['Status'])
    end
  end
end


  





# Scenario: Successfully adding and removing date-time pairs
# When the user fills in the series event form with the following details:
#   | Field       | Value      |
#   | Event Name  | MultiMeet  |
#   | Event Venue | Conference Room A |
# And the user adds two date-time pairs
# And the user removes the last date-time pair
# And the user submits the series event form
# Then the user should see a confirmation that the series event was created
