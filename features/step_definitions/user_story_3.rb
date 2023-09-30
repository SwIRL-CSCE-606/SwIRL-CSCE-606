  Then(/^I should see options for Singular Event, Series Event$/) do
    expect(page).to have_text("Create singular event")
    expect(page).to have_text("Create series event")
    expect(page).to have_text("Check current status")
  end

  When("I click on the Singular Event page") do
    click_link 'Create singular event'
  end

  Then("I should see the Singular Event page") do
    expect(page).to have_text('Event Form')
  end

  Then("I should create an empty event") do
    click_button "Create Event"
  end

  Then("I should be able to see the successful event creation") do
    expect(page).to have_text('Event was successfully created.')
  end

  Then("I should be able to add people to this event") do
    click_button "Add list of people to our event"
  end

  Then("I should be able to see the email field in the page") do
    expect(page).to have_content('Email')
  end

  Then("I click on the Add Button") do
    click_button "Add"
  end