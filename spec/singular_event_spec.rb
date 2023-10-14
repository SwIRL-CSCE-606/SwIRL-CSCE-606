

# spec/features/singular_event_creation_spec.rb
require 'rails_helper'

RSpec.feature 'Create a Singular Event', type: :feature do
  scenario 'Navigate to Singular Event Creation Page' do
    visit root_path
    click_link 'Organizer'
    expect(page).to have_current_path('/home', wait:10)
    expect(page).to have_button('Create singular event')
    expect(page).to have_button('Create series event')
    expect(page).to have_button('Check current status')
  end

  scenario 'Fill in Singular Event Details' do
    visit root_path
    click_link 'Organizer'
    click_link 'Create singular event'
    fill_in 'Event Name', with: 'Test Event'
    fill_in 'Event Venue', with: 'Test Venue'
    fill_in 'Event Date', with: '2023-10-15'
    fill_in 'Event Time', with: '12:00 PM'
    fill_in 'Email', with: 'test@tamu.edu'
    click_button 'Create Event'
    expect(Event.where(name:'Test Event', venue:'Test Venue', date:'2023-10-15', time:'12:00 PM').exists?).to be true
  end
end
