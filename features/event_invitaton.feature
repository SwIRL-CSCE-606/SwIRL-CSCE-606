Feature: Event Invitation Page

  As an invitee
  I want to be able to see event details and respond to the invitation
  So that the organizer knows if I will attend the event or not.

  Scenario: Viewing the event invitation
    Given I am on the event invitation page
    Then I should see "Event Invitation" as the page header
    And I should see the event details
    And I should see the buttons "Yes, I'll Attend" and "No, I Can't Make It"
