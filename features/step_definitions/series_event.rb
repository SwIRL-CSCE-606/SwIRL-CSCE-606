  When("I click on the Series Event page") do
    click_link 'Create series event'
  end

  Then("I should see the Series Event page") do
    expect(page).to have_text('Series Event Form')
  end