Feature: Create a Singular Event
  As an event organizer
  I want to create a one-time event on skhedule.com efficiently
  So that I can easily manage and organize unique events
  
  Scenario: Navigate to Singular Event Creation Page
    Given I am on the Main Page
    When I click on the Organizer Button
    Then I should be on the Organizer Page
    And I should see options for Singular Event, Repeating Event, and Current Status