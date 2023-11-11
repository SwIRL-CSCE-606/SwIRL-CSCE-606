require 'rails_helper'

RSpec.feature 'EventStatus', type: :feature do
  before do
    Event.destroy_all
    EventInfo.destroy_all
    AttendeeInfo.destroy_all

    event = Event.create(name: 'Item 6')
    event_info = EventInfo.create(name: 'Item 6', description: 'event 6', date: DateTime.parse('26-May-2023'), venue: 'Venue 6', start_time: Time.parse('00:00:00AM').in_time_zone('Central Time (US & Canada)'), event: event)
    attendee_info = AttendeeInfo.create(name: 's1mple',  email: 'example7@gmail.com', is_attending: 'false', comments: 'N/A', event: event)

    visit eventsList_path

  end

  it 'displays event information' do
    expect(page).to have_content('Item 6')
    expect(page).to have_content('Friday, 26 May 2023') # matching strftime('%A, %d %b %Y')
    expect(page).to have_content('06:00 AM') # matching strftime('%H:%M %p')
    expect(page).to have_content('Venue 6')
    expect(page).to have_content('s1mple')
    expect(page).to have_content('example7@gmail.com')
    expect(page).to have_content('Not Attending')
  end
end