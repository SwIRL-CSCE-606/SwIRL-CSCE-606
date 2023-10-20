class EventInfo < ApplicationRecord
    self.table_name = 'event_informations'
    belongs_to :event, class_name: 'Event', foreign_key: 'event_id'
end

