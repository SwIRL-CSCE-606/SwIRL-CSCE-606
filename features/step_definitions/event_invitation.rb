Given("I am on the event invitation page") do
    visit event_invitation_path # Assuming your Rails path helper is named this way
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
  