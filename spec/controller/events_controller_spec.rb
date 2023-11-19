require 'rails_helper'

RSpec.describe EventsController, type: :controller do
  let!(:event) { Event.create!(name: 'Original Name') }
  let!(:event_info) do
    EventInfo.create!(
      event_id: event.id,
      name: 'Original Name',
      date: Date.today,
      start_time: Time.now,
      end_time: Time.now + 2.hours
    )
  end
  let!(:attendee_info) { event.attendee_infos.create!(email_token: 'token123', email: 'attendee@example.com') }

  describe 'GET #event_status' do
    let(:events) { Event.all }

    before do
      get :event_status # here we simulate a GET request to the event_status action
    end

    it 'assigns @events' do
      expect(assigns(:events)).to eq(events)
    end

    it 'renders the event_status template' do
      expect(response).to render_template('event_status')
    end

    it 'responds successfully with an HTTP status 200' do
      expect(response).to be_successful
      expect(response).to have_http_status(200)
    end
  end

  describe 'DELETE #destroy' do
    context 'when HTML format is requested' do
      it 'destroys the requested event' do
        expect do
          delete :destroy, params: { id: event.id }
        end.to change(Event, :count).by(-1)
      end

      it 'redirects to the events list with a notice' do
        delete :destroy, params: { id: event.id }
        expect(response).to redirect_to(events_url)
        expect(flash[:notice]).to eq('Event was successfully destroyed.')
      end
    end

    context 'when JSON format is requested' do
      it 'destroys the requested event and returns no content' do
        expect do
          delete :destroy, params: { id: event.id }, format: :json
        end.to change(Event, :count).by(-1)
        expect(response).to have_http_status(:no_content)
      end
    end
  end

  describe 'GET /events/new' do
    it 'returns a successful response' do
      get :new
      expect(response).to be_successful
    end

    it 'renders the new template' do
      get :new
      expect(response).to render_template('new')
    end
  end

  describe 'GET #yes_response' do
    it 'updates attendee_info to yes and redirects' do
      get :yes_response, params: { id: event.id, token: 'token123' }
      attendee_info.reload
      expect(attendee_info.is_attending).to eq('yes')
      expect(response).to redirect_to(event_url(event))
      expect(flash[:notice]).to eq('Your response has been recorded')
    end
  end

  describe 'GET #no_response' do
    it 'updates attendee_info to no and redirects' do
      get :no_response, params: { id: event.id, token: 'token123' }
      attendee_info.reload
      expect(attendee_info.is_attending).to eq('no')
      expect(response).to redirect_to(event_url(event))
      expect(flash[:notice]).to eq('Your response has been recorded')
    end
  end

  describe 'PATCH #update' do
    context 'with valid parameters' do
      let(:valid_params) do
        {
          name: 'Updated Event Name',
          venue: 'New Venue',
          date: Date.tomorrow
        }
      end

      it 'updates the event and redirects (HTML format)' do
        patch :update, params: { id: event.id, event: valid_params }, format: :html
        expect(response).to redirect_to(event_url(event))
        expect(flash[:notice]).to eq('Event was successfully updated.')
        expect(response).to have_http_status(:found) # :found is 302 redirect
      end

      it 'updates the event and renders the show template (JSON format)' do
        patch :update, params: { id: event.id, event: valid_params }, as: :json
        expect(response).to render_template(:show)
        expect(response.content_type).to eq('application/json; charset=utf-8')
        expect(response).to have_http_status(:ok)
      end
    end
    context 'with invalid parameters' do
      # Revised invalid_params to include blatantly wrong types that should fail validation
      let(:invalid_params) do
        {
          name: 25,
          venue: 100,
          date: '',
          start_time: 'no',
          end_time: 'maybe',
          max_capacity: '4fease2'
        }
      end

      it 'does not update the event and re-renders the edit template' do
        patch :update, params: { id: event.id, event: invalid_params }
        expect(response).to render_template(:edit)
        expect(response).to have_http_status(:unprocessable_entity)
      end

      it 'does not update the event_info with invalid data' do
        original_date = event_info.date
        patch :update, params: { id: event.id, event: invalid_params }
        event_info.reload

        expect(event_info.name).not_to eq('')
        expect(event_info.date).to eq(original_date)
        # ... additional checks for other fields can be included here
      end

      it 'returns the correct JSON response with errors when data is invalid' do
        patch :update, params: { id: event.id, event: invalid_params }, as: :json
        expect(response).to have_http_status(:unprocessable_entity)
      end
    end
  end

  describe 'GET #no_response' do
    let(:next_attendee) do
      event.attendee_infos.create!(email_token: 'next_token', email: 'next@example.com', is_attending: nil)
    end

    before do
      allow(Event).to receive(:find).and_return(event)
      allow(event.attendee_infos).to receive(:find_by).and_return(attendee_info)
      allow(attendee_info).to receive(:update).with(is_attending: 'no')

      # Return an ActiveRecord relation instead of an array
      allow(event.attendee_infos).to receive(:where).with(is_attending: nil).and_return(AttendeeInfo.where(id: next_attendee.id))
      allow(event.attendee_infos).to receive(:where).with(is_attending: 'yes').and_return(AttendeeInfo.none)

      allow(EventRemainderMailer).to receive_message_chain(:with, :reminder_email, :deliver)
    end

    it 'updates attendee_info to no, sends reminder email, and redirects' do
      get :no_response, params: { id: event.id, token: 'token123' }
      expect(attendee_info).to have_received(:update).with(is_attending: 'no')
      expect(EventRemainderMailer).to have_received(:with).with(email: 'next@example.com', token: 'next_token',
                                                                event:)
      expect(response).to redirect_to(event_url(event))
      expect(flash[:notice]).to eq('Your response has been recorded')
    end
  end

  describe 'GET #attendees_at_or_over_capacity' do
    let!(:attending_attendees) do
      [
        event.attendee_infos.create!(email_token: 'token1', email: 'attending1@example.com', is_attending: 'yes'),
        event.attendee_infos.create!(email_token: 'token2', email: 'attending2@example.com', is_attending: 'yes')
      ]
    end

    it 'returns attendees at or over capacity' do
      allow(Event).to receive(:find).and_return(event)
      allow(event.event_info).to receive(:max_capacity).and_return(2)

      # Stub only for attendees with is_attending: 'yes'
      allow(event.attendee_infos).to receive(:where).with(is_attending: 'yes').and_return(AttendeeInfo.where(id: attending_attendees.map(&:id)))

      attendees = controller.send(:attendees_at_or_over_capacity)

      expect(attendees).to match_array(attending_attendees)
    end
  end

  describe 'GET #series_event' do
    it 'assigns a new Event to @event' do
      get :series_event
      expect(assigns(:event)).to be_a_new(Event)
    end

    it 'assigns a new EventInfo to @event_info' do
      get :series_event
      expect(assigns(:event_info)).to be_a_new(EventInfo)
    end

    it 'builds a new time slot for the event' do
      get :series_event
      expect(assigns(:event).time_slots.first).to be_a_new(TimeSlot)
    end
  end
  describe 'GET #invite_attendees' do
    before do
      # Setup for the test. Adjust as per your model associations and requirements.
      allow(Event).to receive(:find).with(event.id.to_s).and_return(event)
      allow(event).to receive(:event_info).and_return(event_info)
      allow(EventRemainderMailer).to receive_message_chain(:with, :reminder_email, :deliver)
    end

    context 'when max_capacity is present' do
      before do
        allow(event_info).to receive(:max_capacity).and_return(1)
        get :invite_attendees, params: { id: event.id }
      end

      it 'sends emails up to the max capacity' do
        expect(EventRemainderMailer).to have_received(:with).exactly(1).times
      end

      it 'redirects to events list' do
        expect(response).to redirect_to(eventsList_path)
      end
    end

    context 'when max_capacity is not present' do
      before do
        allow(event_info).to receive(:max_capacity).and_return(nil)
        get :invite_attendees, params: { id: event.id }
      end

      it 'sends emails to all attendees' do
        expect(EventRemainderMailer).to have_received(:with).at_least(:once)
      end

      it 'redirects to events list' do
        expect(response).to redirect_to(eventsList_path)
      end
    end
  end
end
