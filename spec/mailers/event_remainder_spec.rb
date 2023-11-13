require "rails_helper"
require 'tempfile'
require 'csv'
require 'securerandom'

RSpec.describe EventRemainderMailer, type: :mailer do

  describe 'send emails from CSV' do
    it "sends emails from a CSV file" do
      # Set up a CSV file with email addresses for testing
      csv_data = <<~CSV
        email
        aashaykadakia@gmail.com
        aashaykadakia@tamu.edu
      CSV

      # Create a temporary CSV file for testing
      csv_file = Tempfile.new('test_emails.csv')
      csv_file.write(csv_data)
      csv_file.rewind

      # Create an instance of the mailer and pass the csv_file_path as an argument
      mailer = EventRemainderMailer.with(csv_file: csv_file.path).remainder_email(csv_file.path)

      expect {
        mailer.deliver
      }.to change { ActionMailer::Base.deliveries.count }.by(3) # Change this number based on the number of email addresses in your CSV
    end
  end



  describe 'send email from params' do
    it "send a email" do
      email = "test@example.com"

      event = Event.create!(
        name: "Super Awesome Event"
      )
      event_info = EventInfo.create!(
        name:         "Super Awesome Event",
        description:  "Super Cool Event",
        date:         Date.new(2023, 11, 2),
        venue:        "Some Super Cool Place",
        max_capacity: 200,
        start_time:   Time.parse("15:30:20"),
        end_time:     DateTime.new(2023, 11, 2, 17, 30, 0),
        event_id:     event.id  
      )

      attendee_info = AttendeeInfo.create!(
          name: "Erik",
          email: "example@gmail.com",
          is_attending: "yes",
          comments: "super cool",
          email_token: SecureRandom.uuid, 
          event_id: event.id
      )
    
      mailer = EventRemainderMailer.with(email: email, event: event, token: attendee_info.email_token).reminder_email

      expect {
        mailer.deliver
      }.to change { ActionMailer::Base.deliveries.count }.by(1)
    end
  end
end



