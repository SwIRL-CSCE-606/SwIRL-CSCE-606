require 'rails_helper'
require 'tempfile'
require 'csv'
require 'securerandom'

RSpec.describe EventRemainderMailer, type: :mailer do
  describe 'send emails from CSV' do
    it 'sends emails from a CSV file' do
      # Set up a CSV file with email addresses for testing
      csv_data = <<~CSV
        email
        aashaykadakia@gmail.com
        aashaykadakia@tamu.edu
      CSV

      # Create a temporary CSV file for testing
      csv_file = Tempfile.new(['test_emails', '.csv'])
      csv_file.write(csv_data)
      csv_file.rewind

      # Create an instance of the mailer and pass the csv_file_path as an argument
      mailer = EventRemainderMailer.with(csv_file: csv_file.path).remainder_email(csv_file.path)

      # Change this number based on the number of email addresses in your CSV
      expect do
        mailer.deliver
      end.to change {
               ActionMailer::Base.deliveries.count
             }.by(3)
    end
  end

  describe 'send emails from an Excel file' do
    it 'sends emails from an .xlsx file' do
      xlsx_path = Rails.root.join('spec', 'fixtures', 'test_emails.xlsx')

      mailer = EventRemainderMailer.with(xlsx_file: xlsx_path).remainder_email(xlsx_path)

      expect do
        mailer.deliver
      end.to change {
                ActionMailer::Base.deliveries.count
              }.by(4) # Assuming there are 2 emails in the Excel file
    end
  end

  describe 'send email from params' do
    it 'send a email' do
      email = 'test@example.com'

      event = Event.create!(
        name: 'Super Awesome Event'
      )
      event_info = EventInfo.create!(
        name: 'Super Awesome Event',
        description: 'Super Cool Event',
        date: Date.new(2023, 11, 2),
        venue: 'Some Super Cool Place',
        max_capacity: 200,
        start_time: Time.parse('15:30:20'),
        end_time: DateTime.new(2023, 11, 2, 17, 30, 0),
        event_id: event.id
      )

      attendee_info = AttendeeInfo.create!(
        name: 'Erik',
        email: 'example@gmail.com',
        is_attending: 'yes',
        comments: 'super cool',
        email_token: SecureRandom.uuid,
        event_id: event.id
      )

      mailer = EventRemainderMailer.with(email:, event:, token: attendee_info.email_token).reminder_email

      expect do
        mailer.deliver
      end.to change { ActionMailer::Base.deliveries.count }.by(1)
    end
  end

  describe '#event_reminder' do
    let!(:event) { Event.create!(name: 'Original Name') }
    let!(:event_info) do
      EventInfo.create!(
        event_id: event.id,
        name: 'Original Name',
        date: Date.today,
        start_time: Time.now,
        end_time: Time.now + 2.hours,
        venue: 'Some Venue' # Ensure this attribute is included as it's used in the mailer template
      )
    end
    let(:email) { 'test@example.com' }
    let(:token) { SecureRandom.uuid }
    let(:mail) { described_class.with(email:, event:, token:).event_reminder }

    it 'renders the headers' do
      expect(mail.subject).to eq('Event Reminder')
      expect(mail.to).to eq([email])
      expect(mail.from).to eq(['SkheduleSp24@gmail.com']) 
    end
  end

  describe '#reminder_email' do
    context 'when the event has time slots' do
      let(:email) { 'test@example.com' }
      let(:token) { SecureRandom.uuid }
      let(:event_with_time_slots) do
        event = Event.create!(name: 'Event With Time Slots')
        EventInfo.create!(
          event_id: event.id,
          name: 'Original Name',
          date: Date.today,
          start_time: Time.now,
          end_time: Time.now + 2.hours,
          venue: 'Some Venue' # Ensure this attribute is included as it's used in the mailer template
        )
        TimeSlot.create!(event: event, date: Date.today, start_time: Time.now, end_time: Time.now + 1.hour)
        event
      end
      let(:mail) { described_class.with(email: email, event: event_with_time_slots, token: token).reminder_email }
    
      it 'sends email with specific subject and template for series events' do
        expect(mail.subject).to eq('Speaker Event Invitation')
        expect(mail.to).to eq([email])
        expect(mail.body.encoded).to include("You are cordially invited to speak at our event") 
      end
    end
  end
  
  describe '#reminder_email' do
    context 'when the event does not have time slots' do
      let(:email) { 'test@example.com' }
      let(:token) { SecureRandom.uuid }
      let(:event_without_time_slots) do
        event = Event.create!(name: 'Event Without Time Slots')
        EventInfo.create!(
          event_id: event.id,
          name: 'Event Info',
          date: Date.today,
          start_time: Time.now,
          end_time: Time.now + 2.hours,
          venue: 'Event Venue'
        )
        event
      end
      let(:mail) { described_class.with(email: email, event: event_without_time_slots, token: token).reminder_email }

      it 'sends an email invitation for a non-series event' do
        expect(mail.subject).to eq('Event Invitation')
        expect(mail.to).to eq([email])
        expect(mail.body.encoded).to include("You are cordially invited to this upcoming event:")
        
        # Check for an iCalendar attachment
        attachment = mail.attachments.find { |att| att.filename.ends_with?('.ics') }
        expect(attachment).not_to be_nil
        expect(attachment.content_type).to start_with('text/calendar')
      end 
    end
  end 
end
