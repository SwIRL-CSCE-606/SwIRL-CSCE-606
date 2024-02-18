# SKHEDULE.COM

Skhedule.com is a scheduling platform tailored for creating events that have specific attendance needs or capacities. In this web application, there are two types of users (event coordinator and attendee). As event coordinators, users can create events with various options, such as making the event public or private, hosting it once or having it repeat, and adjusting the status of certain guests. The event coordinator is presented with an initial screen where they can choose between two types of events: "Singular" and "Series."<br>

This "Singular" event type is designed for one-time occasions where a specific number of attendees need to be accommodated. The objective here is to invite individuals until the desired number of spots are filled. A practical example of this could be a dinner party, where the host aims to invite guests until all available seats are occupied. On the other hand, the Series event format is suitable for institutions like universities that wish to invite external experts to participate in a lecture series. Unlike one-time events, a Series involves multiple instances or sessions. It is similar to a speaker series, where various experts are invited to deliver talks on different occasions.<br>

As an attendee in a Singular event, one can respond whether they will be able to attend the event or not. Attendees have to confirm their attendance by choosing "Yes" when the invite emails are sent to them. If the attendee selects "No", it means the particular attendee will not be able to attend the event, the email will be sent to the next attendee as per the given priority list.<br>

The emails will be sent out to experts (those who will be delivering lectures) in the Series Event, and they have to choose their preferred time slot. Once, an expert chooses a particular time slot, these slots will be locked and no other experts can choose those time slots. This application perfectly meets the needs of the client. The Stakeholder of this web application is Southwest Innovation Research Lab (SwIRL) and they will use this application for event scheduling purposes. 

# Contact Information

For more information about the project, please feel free to contact our team members!

1. Glen Browne <gdbrowne85@tamu.edu> (Product Owner)
2. Eric McGonagle <ermcgonagle@tamu.edu>
3. Prakhar Singh <prakhar2@tamu.edu>
4. Radha Debal Goswami <debal_goswami@tamu.edu>
5. Carlos Meisel <cmeisel101@tamu.edu>
6. Pankaj Kumar Tiwari <contact_pankaj@tamu.edu>
7. Erhan Wang <ewang41@tamu.edu>

# Links to our resources:

Deployed App - https://swirlskehdule-f316b598c688.herokuapp.com

GitHub Repo - https://github.com/gdbrowne85/SwIRL-CSCE-606

Code Climate Quality Report - https://codeclimate.com/github/gdbrowne85/SwIRL-CSCE-606

Documentation - 

Project Management -

# Prerequisites

Ruby Version: 3.2.2

    rbenv: [Link](https://gorails.com/setup/macos/13-ventura)

    or rvm: [Link](https://rvm.io/rvm/install)

Heroku CLI: [Link](https://devcenter.heroku.com/articles/heroku-cli)

Recommend to use Sonoma 14.0 or Ubuntu 22.04.3: [Link](https://learn.microsoft.com/en-us/windows/wsl/install)

After installing rvm. 

Check rvm version

    rvm -v

You should see the version of rvm, which means you have successfully installed rvm.

Then install and use ruby 3.2.2

    rvm install 3.2.2

    rvm use 3.2.2

    rvm use 3.3.2 --default 

Install postgresql:
On Ubuntu, use apt to install postgresql

    sudo apt update

    sudo apt install postgresql postgresql-contrib

Then, start postgresql service:

    sudo systemctl enable postgresql

    sudo systemctl start postgresql

Check the postgresql service status:

    sudo systemctl status postgresql

Now the postgresql service will be active.

Create a role in postgresql

    sudo -i -u postgres

    psql

Then, create a user and alter the role to superuser

    CREATE USER youruser WITH ENCRYPTED PASSWORD 'yourpassword' SUPERUSER;

# Set up and Deploy

Clone the repository.

    git clone https://github.com/gdbrowne85/SwIRL-CSCE-606/SwIRL-CSCE-606.git

Navigate to project directory

    cd SwIRL-CSCE-606

Install the requried Gem Packages

    bundle install

Run locally using rails

    rails server 

Check that the local server is running. 

Run using Heroku CLI (Heroku must be installed)

    heroku local

Make sure you migrate the db before running

    rails db:schema:load
    rails db:migrate or rails db:migrate RAILS_ENV=development

Testing

Run Cucumber tests

    rails cucumber

    bundle exec cucumber --publish

Run rspec tests

    bundle exec rspec <test path (optional)>

Deploy to Heroku via Heroku CLI

NOTE: Heroku CLI must be installed in your system

Login to Heroku

    heroku login

Create a heroku app

    heroku create <app name>
    
Add Heroku Postgres

    heroku addons:create heroku-postgresql:mini
    
Go to your Heroku console, and add the Heroku remote:

    heroku git:remote -a <app-name>
    
Deploy the app on Heroku:

    git add .
    git commit -am "make it better"
    git push heroku main

Run the migrations:

    heroku run rails db:migrate
  
If needed, seed your database:
   ```
   heroku run rails db:seed
   ```
Open your app in a web browser:
   ```
   heroku open
   ```

For future updates, push changes with:
    ```
    git push heroku main
    ```
And then, go Heroku console to check whether the app is deployed.

Check App Status:

    heroku ps
    
Check Heroku Logs:

    heroku logs
    
Open the deployed application in your web browser:

    heroku open

# Troubleshooting: 

One known issue while running the application locally is that when an invitee tries to accept or reject an event invitation, the API will redirect to prod, and hence, the page will not be reachable (as you are running locally). To overcome this, before capturing your response through email, change the link that the email redirects to (right-click and copy the link address) before clicking "Yes" or "No". <br>

Make sure to remove the defense URL, if you are on a protected network.<br>

For Instance, these are sample URLs for capturing responses:<br> 

Prod URL: http://skhedule-9d55cf93012e.herokuapp.com/events/1/yes_response?token=73eebd46-76a6-4edc-a3ae-0a2e8670ca17 <br>
Local URL: http://127.0.0.1:3000/events/1/yes_response?token=73eebd46-76a6-4edc-a3ae-0a2e8670ca17 <br>

Second, make sure you ask for the master.key for running the Gmail SMTP server locally.<br> Since it is sensitive information, we have not posted the key on the git repo. Please contact the Product Owner for the details of the existing master.key if you are running locally.<br>

If you are deploying the app in Heroku, you need to re-create a rails credentials file with the variables names USER_NAME and PASSWORD which is the corresponding password and user name for the Gmail SMTP.<br>
Create a key to run SMTP using the below commands.

    heroku config:set RAILS_MASTER_KEY=`cat config/master.key`
    heroku rails db:migrate

# Login:

Currently, To login into the Skhedule webapp, use email: 'contact_pankaj@tamu.edu' and password: '1234'. Additional functionalities related to login will be added in the next iteration and details will be updated in this section.
