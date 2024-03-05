Feature: Send Remainder Email

  Scenario Outline: Sending remainder emails to attendees
    Given there is an event named "Test Event"
    And the event has attendees with prepopulated email addresses
    When I trigger the invite_attendees method for the event
    Then remainder emails should be sent to all attendees

