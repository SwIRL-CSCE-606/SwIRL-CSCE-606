Feature: Enter Emails As Text

As an event creator
  I want enter email addresses into a text box
  So that the event invitation can be sent to those email addresses

  Background: 
    Given I am on the event creation page

  Scenario: Successful updating of the attendee info in the event info database
    When the user enters "gdbrowne85@tamu.edu" into the email addresses text box
    And he hits the "Submit" button
    Then he should be on the event data page
    And "gdbrowne85@tamu.edu" should be on that page