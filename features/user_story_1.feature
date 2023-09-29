
Feature: Create a Singular Event
  As an event organizer
  I want to create a one-time event on skhedule.com efficiently
  So that I can easily manage and organize unique events

  Scenario: Navigate to Singular Event Creation Page
    Given I am on the Main Page
    When I click on the Organizer Button
    Then I should be on the Organizer Page
    And I should see options for Singular Event, Repeating Event, and Current Status

  Scenario: Fill in Singular Event Details
    Given I am on the Organizer Page
    When I click on Singular Event
    Then I should be on the Singular Event Creation Page
    And I fill in the following details:
      | Event Name         | Test Event           |
      | Event Venue        | Test Venue           |
      | Event Date         | 2023-10-15           |
      | Max Capacity       | 100                  |
      | Start Time         | 14:00                |
      | End Time           | 16:00                |
      | Duration (minutes) | 120                  |
    And I click on the Submit Button
    Then I should be on the People List Page

  Scenario: Add People to the Singular Event
    Given I am on the People List Page for Test Event
    When I add the following individuals with accommodations:
      | Person Name    | Dietary Restrictions | Accommodations    |
      | John Doe       | Vegetarian           | Wheelchair Access |
      | Jane Smith     | None                 | None              |
    And I click on the Submit Button
    Then I should see a confirmation message
    And the event details should be saved in the database

    






    RSpec

    # spec/features/singular_event_creation_spec.rb
require 'rails_helper'

RSpec.feature 'Create a Singular Event' do
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


