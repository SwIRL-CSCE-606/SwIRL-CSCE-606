Feature: Add people to the singular event
    Scenario: Invite people to an Event
        Given I am on the Main Page
        When I click on the Organizer Button
        Then I should be on the Organizer Page
        When I click on the Singular Event page 
        Then I should see the Singular Event page
        When I fill in "Event Name" with "CSCE 606"
        And  I fill in "Venue" with "Zachery"
        And  I fill in "Date" with "2023-11-03"
        And  I fill in "Max Capacity" with "100"
        And  I fill in "Start Time" with "2023-11-03 11:10:00"
        And  I fill in "End Time" with "2023-11-03 12:20:00"
        And  I upload "test.csv"
        And  I press "Create Event"


    Scenario: View Event Status Page

    Given I went to the Event Status page
    Then I should see the following event information:
        | Field             | Value                   |
        | Event Name        | CSCE 606                |
        | Description       | hall in tamu            |
        | Date              | 2023-11-03              |
        | Start Time        | 2023-11-03 11:10:00     |
        | End Time          | 2023-11-03 12:20:00     |
        | Venue             | Zachery                 |
        | Max. Capacity     | 100                     |
        | Send Invite       | [Button]                |
        | Reminder Invite   | [Button]                |
        | Attendees         | [List of people email IDs] |
        | Add People        | [Button]                |
        | Remove People     | [Button]                |
        | Status            | - Yes: 30
                              - No: 10
                              - No Response: 70

    Scenario: View Event Status Page

    Given I went to the Event Status page
    Then I should see the "Event Name" with "CSCE 606"
    Then I should see the "Description" with "hall in tamu"
    Then I should see the "Date" with "2023-11-03"
    Then I should see the "Start Time" with "2023-11-03 11:10:00"
    Then I should see the "End Time" with "2023-11-03 12:20:00"
    Then I should see the "Venue" with "Zachery"
    Then I should see the "Max. Capacity" with "100"
    Then I should see the "Send Invite" with "[Button]"
    Then I should see the "Reminder Invite" with "[Button]"
    Then I should see the "Attendees" with "[List of people email IDs]"
    Then I should see the "Add People" with "[Button]"
    Then I should see the "Remove People" with "[Button]"
    Then I should see the "Status" with:
        | Yes           | 30 |
        | No            | 10 |
        | No Response   | 70 |
