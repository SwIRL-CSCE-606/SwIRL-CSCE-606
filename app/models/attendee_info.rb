# frozen_string_literal: true

class AttendeeInfo < ApplicationRecord
  belongs_to :event
  has_one :time_slot, required: false

  enum status: {
    not_sent: 0,
    awaiting_reply: 1,
    replied_attending: 2,
    replied_not_attending: 3
  }, _prefix: true
  after_initialize :set_default_status, if: :new_record?

  private
  def set_default_status
    self.status ||= :awaiting_reply
  end
end
