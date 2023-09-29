# features/step_definitions/add_people_steps.rb

Given("I am on the Main Page") do
  visit '/static_pages/main'
end

When("I click on the Organizer Button") do
  click_on 'Organizer'
end

Then("I should be on the Organizer Page") do
  expect(page).to have_content('Organizer Page')
end

And("I should see options for Singular Event, Series Event") do
  expect(page).to have_content('Singular Event')
  expect(page).to have_content('Series Event')
end

When("I click on the Singular Event page") do
  click_on 'Singular Event'
end

Then("I should see the Singular Event page") do
  expect(page).to have_content('Singular Event Page')
end

When("I click on the add people in the singular event") do
  click_on 'Add People'
end

Then("I should see the add people to the singular event page where I can add the email of the persons to be added to a particular singular event") do
  expect(page).to have_content('Add People to Singular Event Page')
end

Given("I am on the Organizer Page") do
  visit '/static_pages/home'
end

When("I click on Singular Event") do
  click_on 'Singular Event'
end

Then("I should be on the Singular Event Creation Page") do
  expect(page).to have_content('Singular Event Creation Page')
end

When("I click on Add people to the event") do
  click_on 'Add People to the Event'
end

Then("I should be on the add people to the event page") do
  expect(page).to have_content('Add People to the Event Page')
end

And("I fill in the following details:") do |table|
  table.hashes.each do |row|
    fill_in 'Email', with: row['Email']
  end
end

And("I click on the Submit Button") do
  click_on 'Submit'
end

Then("this email details should be saved in the database") do
  expect(EventParticipant.find_by(email: 'testemail@gmail.com')).to be_present
end

Given("I am on the People List Page for the Test Event") do
  visit '/people_list'
end

When("I add a person with the following email id:") do |table|
  table.hashes.each do |row|
    fill_in 'Email', with: row['Email']
    click_on 'Add Person'
  end
end

Then("it should add this record to the database and reload the page for the new entry") do
  expect(EventParticipant.find_by(email: 'testemail@gmail.com')).to be_present
end

When("I again add a person with the email id:") do |table|
  table.hashes.each do |row|
    fill_in 'Email', with: row['Email']
    click_on 'Add Person'
  end
end

Then("the email details should be saved in the database") do
  expect(EventParticipant.find_by(email: 'testemail2@gmail.com')).to be_present
end
