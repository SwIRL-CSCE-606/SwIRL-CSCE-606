Feature: I want to create a singular event
    I need to navigate to the singular event page and fill in the appropriate information for the event

    Scenario: I want to navigate to the Event Ogranizer Page
        Given I am on the Main Page
        When I click on the Organizer Button 
        Then I want be on the Event Ogranizer Page

    Scenario: I want to navigate to the Singular Event Page
        Given I am on the Event Organizer Page
        When I click on the Singular Event Button
        Then I want to be on the Singular Event Page
    
    Scenario: I want to create a singular event
        Given I am on the Singular Event Page
        When I fill in the form 
        And I click on the Save Button
        Then I want the event to be saved in the database
        And I want to navigate to the Add People Page



