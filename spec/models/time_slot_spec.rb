require 'rails_helper'

RSpec.describe TimeSlot, type: :model do
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

        @time_slot = TimeSlot.create!(
            date: "2023-11-03",
            start_time: "2023-11-03 11:10:00",
            end_time: "2023-11-03 12:30:00",
            event_id: @event.id
        )
    end

    describe 'time slot actions' do
        it 'edit time slot that exists' do
            _time = Time.now
            @time_slot.update!(end_time: _time)
            @time_slot.reload
            expect(@time_slot.end_time).to eq _time
        end
    
        it 'new time slot' do
            time_slot = TimeSlot.create!(
                date: "2000-11-03",
                start_time: "2000-11-03 11:10:00",
                end_time: "2000-11-03 12:30:00",
                event_id: event.id
            )

            time_slot = TimeSlot.find_by(date: "2000-11-03")
            expect(time_slot.date).to eq "2000-11-03"
            expect(time_slot.start_time).to eq "2000-11-03 11:10:00"
            expect(time_slot.end_time).to eq "2000-11-03 12:30:00"
        end
    
        it 'delete attendee info' do
            time_slot = TimeSlot.find_by(date: "2000-11-03")
            time_slot.destroy
            expect(TimeSlot.find_by(date: "2000-11-03")).to eq nil
        end

    end
end