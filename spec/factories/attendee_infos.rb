# frozen_string_literal: true

FactoryBot.define do
  factory :attendee_info do
    name { 'John Doe' }
    email { 'john.doe@example.com' }
    is_attending { 'yes' }
    event

    trait :attending do
      is_attending { 'yes' }
    end

    trait :not_attending do
      is_attending { 'no' }
    end
  end
end
