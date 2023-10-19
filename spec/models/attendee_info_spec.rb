require 'rails_helper'

RSpec.describe AttendeeInfo, type: :model do
    before do
        @event = Event.create!(
            name: "CSCE 645"
        )

        @attendee = AttendeeInfo.create!(
            name: "Erik",
            email: "example@gmail.com",
            is_attending: "yes",
            comments: "super cool",
            event_id: @event.id
        )
    end

    describe 'attendee info actions' do
        it 'edit attendee info that exists' do
            @attendee.update(email: "example@yahoo.com")
            expect(@attendee.email).to eq "example@yahoo.com"
        end
    
        it 'new attendee info' do
            event = Event.create(name: "CSCE 606")
            AttendeeInfo.create(name: "Karz", event_id: event.id)
            attendee = AttendeeInfo.find_by(name: "Karz")
            expect(attendee.name).to eq "Karz"
        end
    
        it 'delete attendee info' do
            attendee = AttendeeInfo.find_by(name: "Erik")
            attendee.destroy
            expect(AttendeeInfo.find_by(name: "Erik")).to eq nil
        end

    end
end