# README

Project Summary:

#### update this before 20 Nov
The client wants us to create Skhedule.com, which will be a scheduling platform tailored for events that have specific attendance needs or capacities. In our proposed web application, there are two types of users (event coordinator and attendee). As event coordinators, users can create events with various options, such as making the event public or private, hosting it once or having it repeat, and adjusting the status of certain guests. As an attendee, users can choose which event to attend, select their preferred attendance time, book tickets, and cancel them at a later point. Users are required to create an account to send and view invitations but invitees are not. Instead, they can opt to receive an email confirmation with the details and have those details added to their calendar.
Further, upon logging in, the event coordinator or organizer is presented with an initial screen where they can choose between two types of events: "Event" and "Series." 
This event type is designed for one-time occasions where a specific number of attendees need to be accommodated. The objective here is to invite individuals until the desired number of spots are filled. A practical example of this could be a dinner party, where the host aims to invite guests until all available seats are occupied. On the other hand, the Series event format is suitable for institutions like universities that wish to invite external experts to participate in a lecture series. Unlike one-time events, a Series involves multiple instances or sessions. It is similar to a speaker series, where various experts are invited to deliver talks on different occasions. This application perfectly meets the needs of the client. The Stakeholder of this web application is Southwest Innovation Research Lab (SwIRL) and they will use this application for event scheduling purposes. 

Links to our resources:

Deployed App - https://skhedule-9d55cf93012e.herokuapp.com/

GitHub Repo - https://github.com/SwIRL-CSCE-606/SwIRL-CSCE-606

Project Management - https://github.com/orgs/SwIRL-CSCE-606/projects/3/views/1 

Project Details:

* Ruby version: 3.2.2

* System dependencies

* Configuration

* Database creation

* Database initialization

* Services (job queues, cache servers, search engines, etc.)

#### Deployment instructions: 

Deployed App - https://skhedule-9d55cf93012e.herokuapp.com/

###### Tests can be run from the main branch and the testing branch.

###### How to Run Tests:

* Check out the main branch in your local and run the following commands to check the RSpec and Cucumber Coverage.
* rails cucumber   
* bundle exec rspec
