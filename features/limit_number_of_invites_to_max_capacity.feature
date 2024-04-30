Feature: Limit number of invitations sent to the max capacity

  As an event organizer
  So that I can limit the number of invitations sent to the max capacity I choose

  Background:
    Given I am on the home page

  Scenario Outline: Limit invitations to event's max capacity
    When I click on the "Create singular event" button
    And I fill in the event creation form with the following data:
      | Event Name       | Lecture   |
      | Event Venue      | Zachery     |
      | Event Date       | 2023-11-22  |
      | Event Start Time | 18:09       |
      | Event End Time   | 20:09       |
      | Max Capacity     | 10         |
    And I submit the event creation form
    Given I created an event and I click on the "Status" link
    Then I should be on the "Event Dashboard" page
    And I click on "Lecture" event
    Then I extract the max capacity of "Lecture"
    And I count the number of emails sent for the event
    Then the number of emails sent should be less than or equal to the max capacity for the event
