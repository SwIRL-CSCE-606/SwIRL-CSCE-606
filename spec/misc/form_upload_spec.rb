require 'rails_helper'

RSpec.describe EventsController, type: :controller do
  describe 'POST #create' do
    context 'with valid parameters' do
      let(:valid_params) do
        {
          name: 'Test Event',
          venue: 'Test Venue',
          date: Date.today,
          start_time: Time.now,
          end_time: Time.now + 2.hours,
          max_capacity: 100,
          csv_file: fixture_file_upload('spec/fixtures/test.csv', 'csv')
        }
      end

      it 'creates a new event' do
        expect do
          post :create, params: { event: valid_params }
        end.to change(Event, :count).by(1)
      end

      it 'redirects to the created event' do
        post :create, params: { event: valid_params }
        expect(response).to redirect_to(event_path(Event.last))
      end
    end
  end
end
