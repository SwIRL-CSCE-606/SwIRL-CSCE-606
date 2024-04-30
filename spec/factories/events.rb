# frozen_string_literal: true

# FactoryBot.define do
#     factory :event do
#       name { "Sample Event" }
#     #   description { "This is a sample event description." }
#       start_time { Time.now }
#       end_time { 2.hours.from_now }
#     end
#   end

FactoryBot.define do
  factory :event do
    name { 'Sample Event' }
    # Assuming Event has a `name` attribute and an association with EventInfo

    after(:build) do |event|
      # Build an associated event_info but don't save it (use `create` instead of `build` if you want it saved)
      event.event_info ||= build(:event_info, event:)
    end
  end
end
