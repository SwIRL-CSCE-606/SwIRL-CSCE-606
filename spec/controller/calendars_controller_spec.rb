# frozen_string_literal: true

require 'rails_helper'

RSpec.describe CalendarsController, type: :controller do
  describe 'GET #redirect' do
    it 'redirects to the Google OAuth2 authorization URL' do
      get :redirect
      expect(response).to redirect_to(%r{accounts.google.com/o/oauth2/auth})
    end
  end

  describe 'GET #callback' do
    before do
      allow_any_instance_of(Signet::OAuth2::Client).to receive(:fetch_access_token!).and_return({ access_token: 'token' })
    end

    it 'stores the authorization response in the session and redirects' do
      get :callback, params: { code: 'authorization_code' }
      expect(session[:authorization]).to eq({ access_token: 'token' })
      expect(response).to redirect_to(eventsList_url)
    end
  end

  describe 'POST #create_event' do
    let!(:event) { create(:event, id: 1) } # Assuming you have FactoryBot set up for your models

    context 'when authorized' do
      before do
        session[:authorization] = { access_token: 'token' }
        allow_any_instance_of(Signet::OAuth2::Client).to receive(:update!).and_return(true)
        allow_any_instance_of(Google::Apis::CalendarV3::CalendarService).to receive(:insert_event).and_return(true)
      end

      it 'adds the event successfully and redirects' do
        post :create_event, params: { id: 1 }
        expect(flash[:notice]).to eq('Event added successfully!')
        expect(response).to redirect_to(eventsList_url)
      end
    end

    context 'when unauthorized' do
      it 'redirects to the redirect path' do
        post :create_event, params: { id: 1 }
        expect(response).to redirect_to(redirect_path)
      end
    end
  end

  describe 'POST #create_event' do
    context 'when there are attendees for the event' do
      let!(:event) { create(:event) }
      let!(:attendee_info) do
        create(:attendee_info, :attending, event:, name: 'John Doe', email: 'john@example.com', is_attending: 'yes')
      end
      let!(:attendee_info_not_attending) do
        create(:attendee_info, event:, name: 'Jane Doe', email: 'jane@example.com', is_attending: 'no')
      end

      before do
        session[:authorization] = { access_token: 'token' }
        allow_any_instance_of(Signet::OAuth2::Client).to receive(:update!).and_return(true)

        # Mock Google Calendar Service and its insert_event method
        fake_service = instance_double(Google::Apis::CalendarV3::CalendarService)
        allow(Google::Apis::CalendarV3::CalendarService).to receive(:new).and_return(fake_service)
        allow(fake_service).to receive(:authorization=)
        allow(fake_service).to receive(:insert_event) do |_calendar_id, new_event, _options|
          # Here you might assert the format of new_event, particularly its attendees
          expect(new_event.attendees.size).to eq(2) # Assuming you have 2 attendees
          expect(new_event.attendees.map(&:email)).to match_array(['john@example.com', 'jane@example.com'])
          expect(new_event.attendees.map(&:display_name)).to include('John Doe', 'Jane Doe')
          expect(new_event.attendees.map(&:response_status)).to include('accepted', 'needsAction')
        end
      end

      it 'correctly formats and includes all attendees in the new Google Calendar event' do
        post :create_event, params: { id: event.id }
        # Assertions about the response or effects (like flash messages) go here
        expect(flash[:notice]).to eq('Event added successfully!')
        expect(response).to redirect_to(eventsList_url)
      end
    end
  end
end
