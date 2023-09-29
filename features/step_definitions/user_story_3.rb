# features/step_definitions/add_people_steps.rb

Given(/^I am on the Main Page$/) do
  visit root_path
  end

  When(/^I click on the Organizer Button$/) do
    click_link  'Organizer'
  end

  Then(/^I should be on the Organizer Page$/) do
    expect(current_path).to eq home_path
  end

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
    click_on "Create Event"
  end