require 'rails_helper'

RSpec.describe EventsController, type: :controller do
    let!(:event) { Event.create!(name: 'Original Name') }
    let!(:event_info) { EventInfo.create!(event_id: event.id, name: 'Original Name') }

    describe 'GET #event_status' do
        let(:events) { Event.all }
        
        before do
            get :event_status   # here we simulate a GET request to the event_status action
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

    describe 'GET /events/new' do
        it "returns a successful response" do
            get :new
            expect(response).to be_successful
        end

        it "renders the new template" do
            get :new
            expect(response).to render_template('new')
        end
    end


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
                patch :update, params: { id: event.id, event: valid_params}
                event.reload
                event_info.reload
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
            let(:invalid_params) do
                {
                name: 25,
                venue: 100,
                date: "yes",
                start_time: "no",
                end_time: "maybe",
                max_capacity: "4fease2"
                }
            end

            # False positive, doesn't really check for anything substantial need to rewrite
            it 'does not update the event' do
                patch :update, params: { id: event.id, event: invalid_params }
                event.reload
                expect(event.name).not_to eq('Updated Event Name')
            end
        end
    end
end