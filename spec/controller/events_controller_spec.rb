require 'rails_helper'

RSpec.describe EventsController, type: :controller do
  date = Date.today
  s_time = Time.now.utc
  e_time = Time.now.utc + 2.hours
  let!(:event) { Event.create!(name: 'Original Name') }
  let!(:event_info) do
    EventInfo.create!(
      event_id: event.id,
      name: 'Original Name',
      date: date,
      start_time: s_time,
      end_time: e_time,
      max_capacity: 10
    )
  end
  let!(:attendee_info) { event.attendee_infos.create!(email_token: 'token123', email: 'attendee@example.com') }

  # Series Event data
  let!(:event_series) {Event.create!(name: "Series Event")}
  let!(:event_info_series) do 
    EventInfo.create!(
      event_id: event_series.id,
      name: 'Series Event',
      venue: 'Somewhere',
      date: date,
      start_time: s_time,
      end_time: e_time,
    )
  end
  let!(:time_slot) do
    TimeSlot.create!(
      event_id: event_series.id,
      date: date,
      start_time: s_time,
      end_time: e_time,
    )
  end
  let!(:time_slot_1) do
    TimeSlot.create!(
      event_id: event_series.id,
      date: date,
      start_time: s_time,
      end_time: e_time,
    )
  end
  let!(:attendee_info_series) { event_series.attendee_infos.create!(email_token: 'token456', email: 'attendee@example.com') }
  let!(:attendee_info_series_1) { event_series.attendee_infos.create!(email_token: 'token789', email: 'attendee@example.com') }

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

  describe 'GET #yes_response_series' do
    it 'updates attendee_info to yes and time_slot info redirects' do
      get :yes_response_series, params: { id: event_series.id, token: 'token456', time_slot: time_slot.id}
      attendee_info_series.reload
      time_slot.reload
      expect(attendee_info_series.is_attending).to eq('yes')
      expect(time_slot.attendee_info_id).to eq(attendee_info_series.id)
      expect(response).to redirect_to(event_url(event_series))
      expect(flash[:notice]).to eq('Your response has been recorded')
    end

    it 'try to select time_slot that already is owned' do
      get :yes_response_series, params: { id: event_series.id, token: 'token456', time_slot: time_slot.id}
      get :yes_response_series, params: { id: event_series.id, token: 'token789', time_slot: time_slot.id}
      attendee_info_series.reload
      attendee_info_series_1.reload
      time_slot.reload
      expect(attendee_info_series_1.is_attending).to eq(nil)
      expect(time_slot.attendee_info_id).to eq(attendee_info_series.id)
      expect(response).to redirect_to(event_url(event_series))
      expect(flash[:notice]).to eq('Time-slot has already been selected, Please select another one')
    end

    it 'try to select time_slot when attendee already has one assigned' do
      get :yes_response_series, params: { id: event_series.id, token: 'token456', time_slot: time_slot.id}
      get :yes_response_series, params: { id: event_series.id, token: 'token456', time_slot: time_slot_1.id}
      attendee_info_series.reload
      time_slot.reload
      time_slot_1.reload
      expect(attendee_info_series.is_attending).to eq('yes')
      expect(time_slot.attendee_info_id).to eq(attendee_info_series.id)
      expect(response).to redirect_to(event_url(event_series))
      expect(flash[:notice]).to eq('You have already selected a time-slot, Please contact admin to change selected time')
    end

    it 'invalid params' do
      get :yes_response_series, params: { id: event_series.id, token: 'efasef', time_slot: time_slot.id}
      attendee_info_series.reload
      time_slot.reload
      expect(attendee_info_series.is_attending).to eq(nil)
      expect(time_slot.attendee_info_id).to eq(nil)
      expect(response).to redirect_to(event_url(event_series))
      expect(flash[:notice]).to eq('Invalid Response Params')
    end
  end


  describe 'PATCH #update' do
    context 'with valid parameters' do
      let(:valid_params) do
        {
          name: 'Updated Event Name',
          venue: 'New Venue',
          date: Date.tomorrow,
          start_time: Time.new(2000, 01, 01, Time.now.hour, Time.now.min, Time.now.sec, "+00:00"),
          end_time: Time.new(2000, 01, 01, Time.now.hour, Time.now.min, Time.now.sec, "+00:00") + 2.hours,
          max_capacity: 100
        }
      end

      let(:valid_params_series) do
        {
          # "time_slot"=>{"1"=>{"date"=>"2023-12-15", "start_time"=>"16:43:00.000", "end_time"=>"16:44:00.000"}, "2"=>{"date"=>"2023-12-15", "start_time"=>"16:50", "end_time"=>"16:55"}},
          name: 'Updated Event Name',
          venue: 'New Venue',
          time_slots_attributes: [{
            id: 1,
            date: Date.tomorrow,
            start_time: Time.new(2000, 01, 01, Time.now.hour, Time.now.min, Time.now.sec, "+00:00"),
            end_time: Time.new(2000, 01, 01, Time.now.hour, Time.now.min, Time.now.sec, "+00:00") + 2.hours,
          },{
            id: 2,
            date: Date.tomorrow,
            start_time: Time.new(2000, 01, 01, Time.now.hour, Time.now.min, Time.now.sec, "+00:00"),
            end_time: Time.new(2000, 01, 01, Time.now.hour, Time.now.min, Time.now.sec, "+00:00") + 2.hours,
            _destroy: true
          }]
        }
      end
      
      # Check that the expected values are there
      it 'sanity check' do
        expect(event.name).to eq('Original Name')
        expect(event_info.name).to eq('Original Name')
        expect(event_info.date).to eq(date)
        expect(event_info.start_time).to be_within(1.second).of(Time.new(2000, 01, 01, s_time.hour, s_time.min, s_time.sec, "+00:00"))
        expect(event_info.end_time).to be_within(1.second).of(Time.new(2000, 01, 01, e_time.hour, e_time.min, e_time.sec, "+00:00"))
        expect(event_info.max_capacity).to eq(10)
      end

      it 'values are updated for singular event' do
        patch :update, params: { id: event.id, event: valid_params }, format: :html
        event.reload
        expect(event.name).to eq(valid_params[:name])
        expect(event.event_info.venue).to eq(valid_params[:venue])
        expect(event.event_info.date).to eq(valid_params[:date])
        expect(event.event_info.start_time.strftime('%I:%M %p')).to eq(valid_params[:start_time].strftime('%I:%M %p'))
        expect(event.event_info.end_time.strftime('%I:%M %p')).to eq(valid_params[:end_time].strftime('%I:%M %p'))
        expect(event.event_info.max_capacity).to eq(valid_params[:max_capacity])
        expect(response).to redirect_to(event_url(event))
        expect(flash[:notice]).to eq('Event was successfully updated.')
        expect(response).to have_http_status(:found) # :found is 302 redirect
      end

      it 'values are updated for series event' do
        patch :update, params: { id: event_series.id, event: valid_params_series }, format: :html
        event_series.reload
        expect(event_series.name).to eq(valid_params_series[:name])
        expect(event_series.event_info.venue).to eq(valid_params_series[:venue])
        expect(event_series.time_slots.first.date).to eq(Date.tomorrow)
        expect(event_series.time_slots.first.start_time.strftime('%I:%M %p')).to eq(valid_params_series[:time_slots_attributes][0][:start_time].strftime('%I:%M %p'))
        expect(event_series.time_slots.first.end_time.strftime('%I:%M %p')).to eq(valid_params_series[:time_slots_attributes][0][:end_time].strftime('%I:%M %p'))
        expect(event_series.time_slots.size).to eq(1)
        expect(response).to redirect_to(event_url(event_series))
        expect(flash[:notice]).to eq('Event was successfully updated.')
        expect(response).to have_http_status(:found) # :found is 302 redirect
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

  describe 'POST #create' do
    let(:valid_attributes) do
      { name: 'New Event', venue: 'New Venue', date: Date.tomorrow, start_time: Time.now, end_time: Time.now + 2.hours, max_capacity: 50 }
    end

    it 'creates a new event with valid parameters' do
      expect {
        post :create, params: { event: valid_attributes }
      }.to change(Event, :count).by(1)
      expect(response).to redirect_to(event_url(Event.last))
      expect(flash[:notice]).to eq('Event was successfully created.')
    end
  end

  include ActiveJob::TestHelper # Include this if you are processing ActiveStorage attachments or background jobs

  let(:valid_attributes) do
    {
      name: 'Test Event',
      venue: 'Test Venue',
      date: Date.tomorrow,
      start_time: '10:00',
      end_time: '12:00',
      max_capacity: 20
    }
  end

  # excel_file = Rails.root.join('spec', 'fixtures', 'test_emails.xlsx')

  let(:excel_file) do
    fixture_file_upload(Rails.root.join('spec', 'fixtures', 'test_attendees.xlsx'), 'application/vnd.openxmlformats-officedocument.spreadsheetml.sheet')
  end  

  describe 'POST #create with Excel file' do
    it 'creates a new Event and processes attendees from Excel file' do
      expect do
        perform_enqueued_jobs do
          post :create, params: { event: valid_attributes.merge(csv_file: excel_file) }
        end
      end.to change(Event, :count).by(1)
         .and change(EventInfo, :count).by(1)
         .and change(AttendeeInfo, :count).by(2) # Assuming there are 2 attendees in the Excel file

      new_event = Event.last
      expect(new_event.name).to eq(valid_attributes[:name])
      expect(new_event.event_info.venue).to eq(valid_attributes[:venue])
      expect(response).to redirect_to(event_path(new_event)) # Adjust the path as necessary
    end
  end
end
