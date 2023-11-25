Given('the user is on the series event page') do
  visit('/series') # Path for the series event page
end

When('the user fills in the series event form with the following details:') do |table|
  data = table.rows_hash
  fill_in 'Event Name', with: data['Event Name']
  fill_in 'Event Venue', with: data['Event Venue']
end

When('the user adds two date-time pairs') do
  2.times { click_button('Add Date-Time Pair') }

  # Wait for the specific number of date-time pairs to appear

  # expect(page).to have_selector('.date-time-pair', count: 2, wait: 5)

  # Now find all elements with the class '.date-time-pair'
  date_time_pairs = all('.date-time-pair')

  # Debug: Output the number of date-time pairs found
  puts "Date-time pairs found: #{date_time_pairs.size}"

  # Iterate over the found date-time pairs
  date_time_pairs.each_with_index do |pair, index|
    within(pair) do
      # Assuming the date and time fields can be identified without relying on unique IDs
      fill_in 'event[time_slot][][date]', with: (Date.today + index.days).strftime('%Y-%m-%d')
      fill_in 'event[time_slot][][start_time]', with: '09:00'
      fill_in 'event[time_slot][][end_time]', with: '17:00'
    end
  end
end

# When('the user removes the last date-time pair') do
#   Assuming you have a 'Remove' button for each date-time pair
#  all('.remove-date-time').last.click
# end

# And('the user submits the series event form') do
#     # Before submitting, check that date-time pairs are not empty
#     date_times = all('.date-time-pair')
#     if date_times.any? do |pair|
#          pair.find('Date').value.empty? || pair.find('Start Time').value.empty? || pair.find('End Time').value.empty?
#        end
#       raise 'Date and Time fields cannot be empty'
#     end
  
#     click_button('Submit')
#   end
  
#   Then('the user should see a confirmation that the series event was created') do
#     # Adjust the expected text to match what your application will show as a confirmation message
#     expect(page).to have_content('Series event was successfully created')
#   end
# And the user removes the last date-time pair
# And the user submits the series event form
# Then the user should see a confirmation that the series event was created
