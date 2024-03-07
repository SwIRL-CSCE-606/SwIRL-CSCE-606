Given('I am on the event creation page') do
    # Navigate to the event creation page, for example:
    visit '/newEvents'
  end
  
  When('the user enters {string} into the email addresses text box') do |email_address|
    # Fill in the email addresses text box with the provided email address
    fill_in 'Attendee Email', with: email_address
  end
  
  When('he hits the {string} button') do |button_text|
    click_button button_text
  end
  
  Then('he should be on the event data page') do
    # Assert that the user is on the event data page, for example:
    expect(page).to have_current_path('/event_data')
  end
  
  Then('{string} should be on that page') do |user_name|
    # Assert that the user's name is present on the page, for example:
    expect(page).to have_content(user_name)
  end
  