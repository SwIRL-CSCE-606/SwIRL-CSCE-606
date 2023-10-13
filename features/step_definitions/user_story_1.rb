Given(/^I am on the Main Page$/) do
    visit root_path
  end
  
  When(/^I click on the Organizer Button$/) do
    click_link "Event Organizer"
  end
  
  Then(/^I should be on the Organizer Page$/) do
    expect(current_path).to eq home_path
  end
  
  Then(/^I should see options for Singular Event, Repeating Event, and Current Status$/) do
    expect(page).to have_text("Create singular event")
    expect(page).to have_text("Create series event")
    expect(page).to have_text("Check current status")
  end
  
  