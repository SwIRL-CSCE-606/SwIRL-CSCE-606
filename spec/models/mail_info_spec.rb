# spec/controllers/events_controller_spec.rb

require 'rails_helper'

RSpec.describe EventsController, type: :controller do
  describe 'GET #invite_attendees' do
    it 'sends email invitations to all attendees' do
      event = Event.create(name: 'Sample Event') # Create a sample event
      event_info = EventInfo.create(event: event, max_capacity: 10)
      attendee1 = AttendeeInfo.create(email: 'attendee1@example.com', event: event, email_token: 'token1')
      attendee2 = AttendeeInfo.create(email: 'attendee2@example.com', event: event, email_token: 'token2')

      allow_any_instance_of(Event).to receive(:event_info).and_return(event_info)

      expect(EventRemainderMailer).to receive(:with).exactly(2).times.and_return(EventRemainderMailer)
      expect(EventRemainderMailer).to receive(:reminder_email).exactly(2).times.and_return(double(deliver: true))

      get :invite_attendees, params: { id: event.id }
    end

    it 'sends email invitations to a limited number of attendees when at max capacity' do
      event = Event.create(name: 'Sample Event')
      event_info = EventInfo.create(event: event, max_capacity: 5)
      (1..8).each do |i|
        AttendeeInfo.create(email: "attendee#{i}@example.com", event: event, email_token: "token#{i}")
      end

      allow_any_instance_of(Event).to receive(:event_info).and_return(event_info)

      expect(EventRemainderMailer).to receive(:with).exactly(5).times.and_return(EventRemainderMailer)
      expect(EventRemainderMailer).to receive(:reminder_email).exactly(5).times.and_return(double(deliver: true))

      get :invite_attendees, params: { id: event.id }

      expect(response).to redirect_to(eventsList_path)
    end

    it 'redirects to eventsList_path' do
      event = Event.create(name: 'Sample Event') # Create a sample event
      event_info = EventInfo.create(event: event, max_capacity: 10)
      allow_any_instance_of(Event).to receive(:event_info).and_return(event_info)
      get :invite_attendees, params: { id: event.id }
      expect(response).to redirect_to(eventsList_path)
    end
  end

  describe 'GET #send_reminders_to_attendees' do
    it 'sends reminder emails to attendees who responded "yes"' do
      event = Event.create(name: 'Sample Event') # Create a sample event
      event_info = EventInfo.create(event: event, max_capacity: 10)
      attendee1 = AttendeeInfo.create(email: 'attendee1@example.com', event: event, email_token: 'token1', is_attending: 'yes')
      attendee2 = AttendeeInfo.create(email: 'attendee2@example.com', event: event, email_token: 'token2', is_attending: 'yes')
      attendee3 = AttendeeInfo.create(email: 'attendee3@example.com', event: event, email_token: 'token3', is_attending: 'no')

      allow_any_instance_of(Event).to receive(:event_info).and_return(event_info)

      expect(EventRemainderMailer).to receive(:with).exactly(2).times.and_return(EventRemainderMailer)
      expect(EventRemainderMailer).to receive(:event_reminder).exactly(2).times.and_return(double(deliver: true))

      get :send_reminders_to_attendees, params: { id: event.id }

      expect(response).to redirect_to(eventsList_path)
    end

    it 'redirects to eventsList_path even if there are no attendees' do
      event = Event.create(name: 'Sample Event') # Create a sample event
      event_info = EventInfo.create(event: event, max_capacity: 10)

      allow_any_instance_of(Event).to receive(:event_info).and_return(event_info)

      expect(EventRemainderMailer).not_to receive(:with)
      expect(EventRemainderMailer).not_to receive(:event_reminder)

      get :send_reminders_to_attendees, params: { id: event.id }

      expect(response).to redirect_to(eventsList_path)
    end

    it 'does not send reminder emails to attendees who responded "no"' do
      event = Event.create(name: 'Sample Event') # Create a sample event
      event_info = EventInfo.create(event: event, max_capacity: 10)
      attendee1 = AttendeeInfo.create(email: 'attendee1@example.com', event: event, email_token: 'token1', is_attending: 'no')

      allow_any_instance_of(Event).to receive(:event_info).and_return(event_info)

      expect(EventRemainderMailer).not_to receive(:with)
      expect(EventRemainderMailer).not_to receive(:event_reminder)

      get :send_reminders_to_attendees, params: { id: event.id }

      expect(response).to redirect_to(eventsList_path)
    end
  end
end
