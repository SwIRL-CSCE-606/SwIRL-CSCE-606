# spec/features/singular_event_creation_spec.rb
require 'rails_helper'

RSpec.feature 'Create a Singular Event', type:feature do
    scenario 'Navigate to Singular Event Creation Page' do
        visit root_path
        click_on 'Organizer Button'
        expect(page).to have_content('Singular Event')
        expect(page).to have_content('Repeating Event')
        expect(page).to have_content('Current Status')
    end

    scenario 'Fill in Singular Event Details' do
        visit organizer_path
        click_on 'Singular Event'
        fill_in 'Event Name', with: 'Test Event'
        fill_in 'Event Venue', with: 'Test Venue'
        fill_in 'Event Date', with: '2023-10-15'
        fill_in 'Max Capacity', with: '100'
        fill_in 'Start Time', with: '14:00'
        fill_in 'End Time', with: '16:00'
        fill_in 'Duration (minutes)', with: '120'
        click_on 'Submit Button'
        expect(page).to have_content('People List Page')
    end

    scenario 'Add People to the Singular Event' do
        visit people_list_page_path(event: 'Test Event')
        fill_in 'Person Name', with: 'John Doe'
        fill_in 'Dietary Restrictions', with: 'Vegetarian'
        fill_in 'Accommodations', with: 'Wheelchair Access'
        click_on 'Submit Button'
        expect(page).to have_content('Confirmation Message')
        # Add further expectations to check if data is saved in the database
    end
end