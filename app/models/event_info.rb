class EventInfo < ApplicationRecord
    validates :date, presence: true
    belongs_to :event
end
