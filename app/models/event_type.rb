class EventType < ApplicationRecord
    has_many :events, dependent: :destroy
end
  
