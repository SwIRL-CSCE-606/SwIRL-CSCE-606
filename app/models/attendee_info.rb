# frozen_string_literal: true

class AttendeeInfo < ApplicationRecord
  belongs_to :event
  has_one :time_slot, required: false
end
