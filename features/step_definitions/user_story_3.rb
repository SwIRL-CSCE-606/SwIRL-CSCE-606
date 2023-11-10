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

  Then("I should be able to see upload csv option") do
    expect(page).to have_selector('input[type="file"]')
  end

  Then("I should upload csv file") do 
    file_path = Rails.root.join('features', 'step_definitions', 'files', 'test.csv')
    response = attach_file('csv_file', file_path)
  end