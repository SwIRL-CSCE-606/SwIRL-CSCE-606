Feature: Series Event Creation

  As a user
  I want to create a series event
  So that multiple occurrences of the event can be managed together

  Background: 
    Given the user is on the series event page

  Scenario: Successfully adding and removing date-time pairs
    When the user fills in the series event form with the following details:
      | Field       | Value      |
      | Event Name  | MultiMeet  |
      | Event Venue | Conference Room A |
    And the user adds two date-time pairs

