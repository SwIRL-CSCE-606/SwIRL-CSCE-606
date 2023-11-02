require 'rails_helper'

RSpec.describe EventsController, type: :controller do
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

    describe 'GET /events/:id' do
        
    end
end