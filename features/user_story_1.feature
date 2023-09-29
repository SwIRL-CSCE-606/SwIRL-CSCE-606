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
      | Time               | 14:00                |
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

  






