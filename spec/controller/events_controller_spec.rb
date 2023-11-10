require 'rails_helper'

RSpec.describe EventsController, type: :controller do
  let!(:event) { Event.create!(name: 'Original Name') }
  let!(:event_info) { EventInfo.create!(event_id: event.id, name: 'Original Name', date: Date.today) }
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
          date: Date.tomorrow,
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

  describe 'POST #create' do
    context 'when parsed_data is empty' do
      it 'handles empty parsed_data gracefully' do
        post :create, params: { event: { name: 'Test Event', parsed_data: [] } }
        expect(flash[:alert]).to eq('parsed_data is empty')
        expect(response).to render_template(:new)
      end
    end
  end

  # This test ensures the controller responds with unprocessable_entity when the event can't be saved
  describe 'POST #create' do
    context 'when the event is invalid' do
      it 'does not create a new event and renders the new template with errors' do
        post :create, params: { event: { name: nil } }, format: :html
        expect(response).to render_template(:new)
        expect(response).to have_http_status(:unprocessable_entity)
      end
    end
  end
end
