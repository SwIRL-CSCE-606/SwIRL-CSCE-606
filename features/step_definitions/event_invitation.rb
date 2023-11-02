Given("I am on the event invitation page") do
    visit test_email_invitation_path
  end
    
  Then("I should see {string} as the page header") do |header_text|
    expect(page).to have_selector('.event-header', text: header_text)
  end
  
  Then("I should see the event details") do
    # Check for a few event details as an example
    expect(page).to have_content("Event Name:")
    expect(page).to have_content("Date:")
    expect(page).to have_content("Time:")
    expect(page).to have_content("Location:")
    expect(page).to have_content("Description:")
  end
  
  Then("I should see the buttons {string} and {string}") do |btn1, btn2|
    expect(page).to have_button(btn1)
    expect(page).to have_button(btn2)
  end
  

  When('I fill in {string} with {string}') do |string, string2|
    fill_in string, with: string2
  end
  
  When('I upload {string}') do |string|
    file_path = Rails.root.join('features', 'step_definitions', 'files', string)
    attach_file('csv_file', file_path)
  end
  
  When('I press {string}') do |string|
    click_button string
  end