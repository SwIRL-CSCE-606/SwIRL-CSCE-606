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

  describe 'POST #create_event' do
    let(:event) { create(:event) }
    let(:event_info) { create(:event_info, event:) }
    let(:fake_service) { instance_double(Google::Apis::CalendarV3::CalendarService) }
    let!(:time_slots) do
      [
        create(:time_slot, event:, date: Date.today, start_time: '09:00', end_time: '10:00'),
        create(:time_slot, event:, date: Date.today, start_time: '11:00', end_time: '12:00')
      ]
    end
    let(:attendees) do
      [
        create(:attendee_info, event:, email: 'attendee1@example.com', is_attending: 'yes'),
        create(:attendee_info, event:, email: 'attendee2@example.com', is_attending: 'no')
      ]
    end


    # before do
    #   session[:authorization] = { access_token: 'token' }
    #   allow_any_instance_of(Google::Apis::CalendarV3::CalendarService).to receive(:insert_event).and_return(true)
    # end
    before do
      allow(Google::Apis::CalendarV3::CalendarService).to receive(:new).and_return(fake_service)
      allow(fake_service).to receive(:authorization=) # Allow setting authorization
      allow(fake_service).to receive(:insert_event).and_return(true) # Stubbing the insert event
    end

    # it 'creates events in Google Calendar for each time slot' do
    #   expect do
    #     post :create_event, params: { id: event.id }
    #     # expect(flash[:notice]).to eq('Series event added successfully!')
    #   end.to change { flash[:notice] }.to('Series event added successfully!')
    #   # end
    # end

    it 'formats time correctly for Google Calendar events' do
      fake_service = instance_double(Google::Apis::CalendarV3::CalendarService)
      allow(Google::Apis::CalendarV3::CalendarService).to receive(:new).and_return(fake_service)
      allow(fake_service).to receive(:insert_event) do |_calendar_id, new_event, _options|
        expect(new_event.start.date_time).to match(/\d{4}-\d{2}-\d{2}T\d{2}:\d{2}:\d{2}.\d{3}Z/)
        expect(new_event.end.date_time).to match(/\d{4}-\d{2}-\d{2}T\d{2}:\d{2}:\d{2}.\d{3}Z/)
      end

      post :create_event, params: { id: event.id }
    end

    it 'assigns the correct attendees to the event' do
      fake_service = instance_double(Google::Apis::CalendarV3::CalendarService)
      allow(Google::Apis::CalendarV3::CalendarService).to receive(:new).and_return(fake_service)
      allow(fake_service).to receive(:insert_event) do |_calendar_id, new_event, _options|
        expect(new_event.attendees.count).to eq(2)
        expect(new_event.attendees.map(&:email)).to match_array(['attendee1@example.com', 'attendee2@example.com'])
        expect(new_event.attendees.map(&:response_status)).to contain_exactly('accepted', 'needsAction')
      end

      post :create_event, params: { id: event.id }
    end
  end

  describe 'POST #create_event' do
    let(:event) { create(:event) }
    let(:event_info) { create(:event_info, event: event) }
    let!(:time_slots) do
      create_list(:time_slot, 2, event: event, date: Date.today, start_time: '09:00', end_time: '10:00')
    end
    let!(:attendee_info) { create(:attendee_info, event: event, email: 'attendee@example.com', name: 'Attendee One', is_attending: 'yes') }

    before do

      allow(controller).to receive(:authorized?).and_return(true)
      session[:authorization] = { access_token: 'fake_token' }
      signet_double = instance_double(Signet::OAuth2::Client)
      allow(Signet::OAuth2::Client).to receive(:new).and_return(signet_double)
      allow(signet_double).to receive(:update!).and_return(true)
      
      @service_double = instance_double(Google::Apis::CalendarV3::CalendarService)
      allow(Google::Apis::CalendarV3::CalendarService).to receive(:new).and_return(@service_double)
      allow(@service_double).to receive(:authorization=)
      allow(@service_double).to receive(:insert_event).and_return(Google::Apis::CalendarV3::Event.new(id: 'new_event_id'))
    end

    it 'creates Google Calendar events for each time slot and assigns attendees correctly' do
      expect(@service_double).to receive(:insert_event).twice

      post :create_event, params: { id: event.id }

      expect(flash[:notice]).to eq('Series event added successfully!')
      expect(response).to redirect_to(eventsList_url)
    end
  end

  describe 'POST #create_event' do
    let(:event) { create(:event) }
    
    before do
      allow(controller).to receive(:authorized?).and_return(true)
      session[:authorization] = { access_token: 'fake_token' }
      @service_double = instance_double(Google::Apis::CalendarV3::CalendarService)
      allow(Google::Apis::CalendarV3::CalendarService).to receive(:new).and_return(@service_double)
      allow(@service_double).to receive(:authorization=)
    end

    context 'when Google API raises an error' do
      before do
        allow(@service_double).to receive(:insert_event).and_raise(Google::Apis::Error.new("Something went wrong"))
      end

      it 'rescues the Google::Apis::Error and redirects to the redirect path' do
        post :create_event, params: { id: event.id }
        expect(response).to redirect_to(redirect_path)
      end
    end
  end 

end
