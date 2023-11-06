Feature: Displaying event status

  Scenario: Viewing the event status
    Given I visit the event status page
    Then I should see the details of the events
    And I should see the list of attendees for each event

  Scenario: Verifying event details
    Given I visit the event status page
    Then I should see "Sample Event 1" as an event name
    And I should see "This is a sample event" as the event description
    And I should see "Sample Location 1" as the event location
    And I should see "Yes: 50" and "No: 20" as the invite status for "Sample Event 1"
    And I should see "John Doe" with status "Attending" in the attendees list
    And I should see "Jane Smith" with status "Not Attending" in the attendees list


  Scenario: Verifying another event details
    Given I visit the event status page
    Then I should see "Sample Event 2" as an event name
    And I should see "This is another sample event" as the event description
    And I should see "Sample Location 2" as the event location
    And I should see "Yes: 30" and "No: 40" as the invite status for "Sample Event 2"
