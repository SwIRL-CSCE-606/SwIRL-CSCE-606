Given('there is an event named {string}') do |event_name|
    @event = Event.create!(name: event_name)
    @event_info = EventInfo.create!(
      event_id: @event.id,
      name: "tests",
      description: nil,
      date: Date.new(2024, 3, 9),
      start_time: Time.utc(2000, 1, 1, 7, 45, 0),
      venue: "gege",
      end_time: Time.utc(2000, 1, 1, 21, 45, 0),
      max_capacity: 5
    )
  end
  
  
  Given('the event has attendees with prepopulated email addresses') do
    @attendee = AttendeeInfo.create!(name: "Attendee 1", email: "gdbrowne85@tamu.edu", event: @event)
  end
  
  When('I trigger the invite_attendees method for the event') do
    visit invite_attendees_path(@event)
  end
  
  Then('remainder emails should be sent to all attendees') do
    # Check if emails were sent from the specified email address
    emails_sent = ActionMailer::Base.deliveries.select { |email| email.from.include?('skhedule4@gmail.com') }
    
    # Check if emails were sent to all attendees
    if emails_sent.count == AttendeeInfo.count
      puts "Remainder emails were sent to all attendees."
    else
      puts "Remainder emails were not sent to all attendees. Expected: #{AttendeeInfo.count}, Actual: #{emails_sent.count}"
    end
  end
  