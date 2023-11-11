require 'rails_helper'

RSpec.describe EventInfo, type: :model do
    before do
        @event = Event.create!(
            name:       "CSCE 606"
        )

        @event_info = EventInfo.create!( 
            name:           "CSCE 606",
            description:    "super cool event",
            date:           "2023-00-00",
            venue:          "Rudder Theatre",
            event_id:       @event.id
        )
        
    end

    describe 'event actions' do
        it 'edit event info' do
            event_info = EventInfo.find_by(name: "CSCE 606")
            event_info.update(venue: "HRBB")
            expect(event_info.venue).to eq "HRBB"
        end

        it 'new event info' do
            EventInfo.create(name: "CSCE 645", event_id: @event.id)
            event_info = EventInfo.find_by(name: "CSCE 645")
            expect(event_info.name).to eq "CSCE 645"
        end


        it 'delete event info' do
            event_info = EventInfo.find_by(name: "CSCE 606")
            event_info.destroy
            expect(EventInfo.find_by(name: "CSCE 606")).to eq nil
        end
    end
end
