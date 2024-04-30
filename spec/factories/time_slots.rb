# spec/factories/time_slots.rb
FactoryBot.define do
    factory :time_slot do
      event
      date { Date.today }
      start_time { '09:00' }
      end_time { '10:00' }
    end
  end