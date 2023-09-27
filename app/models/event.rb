class Event < ApplicationRecord
  belongs_to :event_type
  has_many :event_informations, dependent: :destroy
end

