# frozen_string_literal: true

class EventInfo < ApplicationRecord
  validates :date, presence: true
  belongs_to :event
  attribute :reminder_time, :datetime
end
