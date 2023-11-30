class TimeSlot < ApplicationRecord
    belongs_to :event
    belongs_to :attendee_info, required: false
end
