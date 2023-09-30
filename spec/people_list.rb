# spec/features/singular_event_creation_spec.rb
require 'rails_helper'

RSpec.feature 'Event Form page', type: :feature do
  scenario 'Navigate to Create Event' do
    visit root_path
    click_link 'Organizer'
    expect(page).to have_current_path('/home', wait:10)
    click_link 'Create singular event'
    expect(page).to have_button('Create Event')

  end

  scenario 'Navigate to Add Email' do
      visit root_path
      click_link 'Organizer'
      expect(page).to have_current_path('/home', wait:10)
      click_link 'Create singular event'
      expect(page).to have_button('Create Event')
      click_button 'Create Event'
      click_button 'Add list of people to our event'
      expect(page).to have_button('Add')
      expect(page).to have_button('Submit')
    end

end
