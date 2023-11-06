# spec/controllers/events_controller_spec.rb

require 'rails_helper'

RSpec.describe EventsController, type: :controller do
  describe 'GET #invite_attendees' do
    it 'sends email invitations to all attendees' do
      event = Event.create(name: 'Sample Event') # Create a sample event
      attendee1 = AttendeeInfo.create(email: 'attendee1@example.com', event: event, email_token: 'token1')
      attendee2 = AttendeeInfo.create(email: 'attendee2@example.com', event: event, email_token: 'token2')

      expect(EventRemainderMailer).to receive(:with).exactly(2).times.and_return(EventRemainderMailer)
      expect(EventRemainderMailer).to receive(:reminder_email).exactly(2).times.and_return(double(deliver: true))

      get :invite_attendees, params: { id: event.id }
    end

    it 'redirects to eventsList_path' do
      event = Event.create(name: 'Sample Event') # Create a sample event
      get :invite_attendees, params: { id: event.id }
      expect(response).to redirect_to(eventsList_path)
    end
  end
end
