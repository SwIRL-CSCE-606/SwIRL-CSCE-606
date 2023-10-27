Feature: Add people to the singular event
  As an event organizer
  I want to add people to the singular event on skhedule.com 
  So that I can manage the list of people attending the particular singular event

  Scenario: Create an empty singular event
    Given I am on the Main Page
    When I click on the Organizer Button
    Then I should be on the Organizer Page
    And I should see options for Singular Event, Series Event
    When I click on the Singular Event page 
    Then I should see the Singular Event page