class Event < ApplicationRecord
    has_many :attendee_infos
    has_many :time_slots
    accepts_nested_attributes_for :time_slots, allow_destroy: true
    has_one :event_info 
    has_one_attached :csv_file
end

