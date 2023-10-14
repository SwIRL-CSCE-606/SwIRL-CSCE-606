require 'rails_helper'

RSpec.describe Attendeeinfo, type: :model do
    before do
        @event = Event.new 
        @event.name = "CSCE 645"

        @attendee = Attendeeinfo.new
        @attendee.name = "Erik"
        @attendee.email = "example@gmail.com"
        @attendee.isattending = "yes"
        @attendee.comments = "super cool"
        @attendee.event_id = @event.id
    end

    describe 'edit attendeeinfo' do
        it 'edit attendeeinfo that exists' do
            @attendee.update(email: "example@yahoo.com")
            expect(@attendee.email).to eq "example@yahoo.com"
        end
    end

    describe 'new attendeeinfo' do
        it 'new attendeeinfo' do
            event = Event.create(name: "CSCE 606")
            Attendeeinfo.create(name: "Karz", event_id: event.id)
            attendee = Attendeeinfo.find_by(name: "Karz")
            expect(attendee.name).to eq "Karz"
        end
    end

    describe 'delete attendeeinfo' do
        it 'delete attendeeinfo' do
            attendee = @attendee
            attendee.destroy
            expect(Attendeeinfo.find_by(name: "Erik")).to eq nil
        end
    end

end