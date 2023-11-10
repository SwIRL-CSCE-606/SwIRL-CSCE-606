require 'rails_helper'

RSpec.describe TimeSlot, type: :model do
  let(:event) { Event.create!(name: 'CSCE 645') }

  describe 'time slot actions' do
    let(:time_slot) do
      TimeSlot.create!(
        date: '2023-11-03',
        start_time: '11:10:00',
        end_time: '12:30:00',
        event_id: event.id
      )
    end

    it 'updates end time of an existing time slot' do
      new_end_time = Time.current.change(year: 2000, day: 1, month: 1).strftime('%H:%M:%S')
      time_slot.update!(end_time: new_end_time)
      
      expect(time_slot.reload.end_time.strftime('%H:%M:%S')).to eq new_end_time
    end

    it 'creates a new time slot' do
      expect(time_slot.date.to_s).to eq '2023-11-03'
      expect(time_slot.start_time.strftime('%H:%M:%S')).to eq '11:10:00'
      expect(time_slot.end_time.strftime('%H:%M:%S')).to eq '12:30:00'
    end

    it 'deletes a time slot' do
      time_slot # create the time slot
      time_slot_id = time_slot.id
      time_slot.destroy

      expect(TimeSlot.find_by(id: time_slot_id)).to be_nil
    end
  end
end
