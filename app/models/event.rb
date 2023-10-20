class Event < ApplicationRecord
    has_many :attendee_infos
    accepts_nested_attributes_for :attendee_infos
    has_one :event_information, class_name: 'EventInfo', foreign_key: 'event_id'
end
