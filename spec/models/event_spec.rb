require 'rails_helper'

RSpec.describe Event, type: :model do
    before do
        @event = Event.create!( 
            name:       "CSCE 606"
        )
        
        @event_info = EventInfo.create!(
            name:       "CSCE 606",
            event_id:   @event.id,
            date: Date.today, 
        )

        @attendee = AttendeeInfo.create!(
            name:       "Josh",
            event_id:   @event.id
        )


    end

    describe 'event actions' do
        it 'edit event' do
            event = Event.find_by(name: "CSCE 606")
            event.update(name: "CSCE 645")
            expect(event.name).to eq "CSCE 645"
        end

        it 'new event' do
            Event.create(name: "CSCE 645")
            event = Event.find_by(name: "CSCE 645")
            expect(event.name).to eq "CSCE 645"
        end

        it 'delete event' do
            event = Event.find_by(name: "CSCE 606")
            event_id = event.id
            event.destroy
            expect(Event.find_by(name: "CSCE 606")).to eq nil
            expect(EventInfo.find_by(event_id: event_id)).to eq nil
            expect(AttendeeInfo.find_by(event_id: event_id)).to eq nil
        end
    end

end
