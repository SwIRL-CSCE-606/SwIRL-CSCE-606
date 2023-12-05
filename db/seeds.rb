
# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the bin/rails db:seed command (or created alongside the database with db:setup).
#
# Examples:
#
#   movies = Movie.create([{ name: "Star Wars" }, { name: "Lord of the Rings" }])
#   Character.create(name: "Luke", movie: movies.first)

#           -----------Event----------
#           |                        |
#           |                        |
#           +(many)                  *(one)
#      AttendeeInfo               EventInfo
#

# Data for AttendeeInfos Table
attendee_infos = [
  { name: 'Erik',     email: 'example1@gmail.com', is_attending: 'true',   comments: 'N/A'},
  { name: 'Mohit',    email: 'example2@gmail.com', is_attending: 'false',  comments: 'N/A'},
  { name: 'Aashay',   email: 'example3@gmail.com', is_attending: 'true',   comments: 'N/A'},
  { name: 'Chong',    email: 'example4@gmail.com', is_attending: 'false',  comments: 'N/A'},
  { name: 'Ishant',   email: 'example5@gmail.com', is_attending: 'false',  comments: 'N/A'},
  { name: 'Shaunak',  email: 'example6@gmail.com', is_attending: 'true',   comments: 'N/A'}
]


# Data for EventInfos Table
event_infos = [
  { name: 'Item 1', description: 'event 1', date: '01-Jan-2023', venue: 'Venue 1', start_time:'00:00:00AM', end_time:'02:00:00AM'},
  { name: 'Item 2', description: 'event 2', date: '15-Feb-2023', venue: 'Venue 2', start_time:'00:00:00AM', end_time:'02:00:00AM'},
  { name: 'Item 3', description: 'event 3', date: '30-Mar-2023', venue: 'Venue 3', start_time:'00:00:00AM', end_time:'02:00:00AM'},
  { name: 'Item 4', description: 'event 4', date: '10-Apr-2023', venue: 'Venue 4', start_time:'00:00:00AM', end_time:'02:00:00AM'},
  { name: 'Item 5', description: 'event 5', date: '25-May-2023', venue: 'Venue 5', start_time:'00:00:00AM', end_time:'02:00:00AM'}
]

# Data for Events Table
events = [
  { name: 'Item 1'},
  { name: 'Item 2'},
  { name: 'Item 3'},
  { name: 'Item 4'},
  { name: 'Item 5'}
]




# Create entries for Event Table, EventInfos Table, and AttendeeInfos Tables
# Create entries for Event Table, EventInfos Table, and AttendeeInfos Tables
events.each_with_index do |event_data, index|
  # Create Event entry
  event = Event.create!(event_data)

  # Create EventInfos entry
  event_info = EventInfo.create!(
    name: event_infos[index][:name],
    description: event_infos[index][:description],
    date: event_infos[index][:date],
    venue: event_infos[index][:venue],
    start_time: event_infos[index][:start_time],
    end_time: event_infos[index][:end_time],
    event_id: event.id
  )

  # Create unique attendees per event
  attendee_infos.each do |attendee_data|
    attendee = AttendeeInfo.create!(
      name: attendee_data[:name],
      email: attendee_data[:email],
      is_attending: attendee_data[:is_attending],
      comments: attendee_data[:comments],
      event_id: event.id
    )
  end

  # Update reference from event_id to new tables
  event.update!(event_info_id: event_info.id)
end




#   accounts = [
#     { :email => 'user1@example.com', :name => 'User One', :password_digest => 'password1' },
#     { :email => 'user2@example.com', :name => 'User Two', :password_digest => 'password2' },
#     { :email => 'user3@example.com', :name => 'User Three', :password_digest => 'password3' },
#     { :email => 'user4@example.com', :name => 'User Four', :password_digest => 'password4' },
#     { :email => 'user5@example.com', :name => 'User Five', :password_digest => 'password5' }
#   ]

#   accounts.each do |create_account|
#     CreateAccounts.create!(create_account)
#   end
