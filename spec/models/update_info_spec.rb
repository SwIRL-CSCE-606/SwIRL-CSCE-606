# spec/controllers/events_controller_spec.rb

require 'rails_helper'

RSpec.describe EventsController, type: :controller do
  let(:event) { Event.create(name: 'Original Name') }
  let(:event_info) { EventInfo.create(event: event, name: 'Original Name') }

  describe 'PATCH #update' do
    context 'with valid parameters' do
      let(:valid_params) do
        {
          name: 'Updated Event Name',
          venue: 'Updated Venue',
          date: Date.tomorrow,
          start_time: Time.now,
          end_time: Time.now + 2.hours,
          max_capacity: 150
        }
      end

      it 'updates the event' do
        patch :update, params: { id: event.id, event: valid_params }
        event.reload
        expect(event.name).to eq('Updated Event Name')
      end

      it 'updates the event_info' do
        patch :update, params: { id: event.id, event: valid_params }
        event_info.reload
        expect(event_info.name).to eq('Updated Event Name')
        expect(event_info.venue).to eq('Updated Venue')
      end

      it 'redirects to the updated event' do
        patch :update, params: { id: event.id, event: valid_params }
        expect(response).to redirect_to(event_url(event))
      end

      it 'sets a notice message' do
        patch :update, params: { id: event.id, event: valid_params }
        expect(flash[:notice]).to eq('Event was successfully updated.')
      end
    end

    context 'with invalid parameters' do

      it 'does not update the event' do
        patch :update, params: { id: event.id, event: invalid_params }
        event.reload
        expect(event.name).not_to eq('Updated Event Name')
      end
    end
  end
end
