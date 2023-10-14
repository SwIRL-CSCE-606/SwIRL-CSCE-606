  Then(/^I should see options for Singular Event, Series Event$/) do
    expect(page).to have_text("Create singular event")
    expect(page).to have_text("Create series event")
    expect(page).to have_text("Check current status")
  end

  When("I click on the Singular Event page") do
    click_link 'Create singular event'
  end

  Then("I should see the Singular Event page") do
    expect(page).to have_text('Event name')
  end

  Then("I should add a test email") do
    fill_in 'Email', with: "testuser@gmail.com"
  end

  Then("I should create an event") do
    click_button "Create Event"
  end

  Then("I should be able to see the successful event creation") do
    expect(page).to have_text('Event was successfully created.')
  end