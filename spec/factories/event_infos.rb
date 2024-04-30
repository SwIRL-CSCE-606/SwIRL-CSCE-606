# frozen_string_literal: true

FactoryBot.define do
  factory :event_info do
    # Assuming the EventInfo model has these attributes; adjust as needed
    name { 'Event Info Name' }
    venue { 'Some Venue' }
    date { Date.today }
    start_time { Time.now }
    end_time { 2.hours.from_now }
    # Add other necessary attributes here
    event
  end
end
