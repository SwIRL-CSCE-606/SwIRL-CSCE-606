# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the bin/rails db:seed command (or created alongside the database with db:setup).
#
# Examples:
#
#   movies = Movie.create([{ name: "Star Wars" }, { name: "Lord of the Rings" }])
#   Character.create(name: "Luke", movie: movies.first)


more_singular_event = [
    { name: 'Item 1', date: '01-Jan-2023', description: 'Description 1', comments: 'Comment 1' },
    { name: 'Item 2', date: '15-Feb-2023', description: 'Description 2', comments: 'Comment 2' },
    { name: 'Item 3', date: '30-Mar-2023', description: 'Description 3', comments: 'Comment 3' },
    { name: 'Item 4', date: '10-Apr-2023', description: 'Description 4', comments: 'Comment 4' },
    { name: 'Item 5', date: '25-May-2023', description: 'Description 5', comments: 'Comment 5' }
  ]


  more_singular_event.each do |singular_event|
    Singular_Event.create!(singular_event)
  end

  more_create_event = [
    { :event_type => 'Type A', :name => 'Event 1', :description => 'Description for Event 1' },
    { :event_type => 'Type B', :name => 'Event 2', :description => 'Description for Event 2' },
    { :event_type => 'Type C', :name => 'Event 3', :description => 'Description for Event 3' },
    { :event_type => 'Type A', :name => 'Event 4', :description => 'Description for Event 4' },
    { :event_type => 'Type B', :name => 'Event 5', :description => 'Description for Event 5' }
  ]

  more_create_event.each do |create_event|
    CreateEvents.create!(create_event)
  end

  more_create_event_type = [
    { name: 'Item 1' },
    { name: 'Item 2' },
    { name: 'Item 3' },
    { name: 'Item 4' },
    { name: 'Item 5' },
    { name: 'Item 6' },
  ]

  more_create_event_type.each do |create_event_type|
    CreateEventTypes.create!(create_event_type)
  end

  more_create_information = [
    { :event => 'Event 1', :date => '2023-10-10', :time => '10:00 AM', :venue => 'Venue A', :description => 'Description for Event 1' },
    { :event => 'Event 2', :date => '2023-10-15', :time => '3:30 PM', :venue => 'Venue B', :description => 'Description for Event 2' },
    { :event => 'Event 3', :date => '2023-10-20', :time => '7:00 PM', :venue => 'Venue C', :description => 'Description for Event 3' },
    { :event => 'Event 4', :date => '2023-10-25', :time => '2:00 PM', :venue => 'Venue D', :description => 'Description for Event 4' },
    { :event => 'Event 5', :date => '2023-10-30', :time => '6:30 PM', :venue => 'Venue E', :description => 'Description for Event 5' }
  ]
  
  more_create_information.each do |create_event_information|
    CreateEventInformations.create!(create_event_information)
  end


  more_create_accounts = [
    { :email => 'user1@example.com', :name => 'User One', :password_digest => 'password1' },
    { :email => 'user2@example.com', :name => 'User Two', :password_digest => 'password2' },
    { :email => 'user3@example.com', :name => 'User Three', :password_digest => 'password3' },
    { :email => 'user4@example.com', :name => 'User Four', :password_digest => 'password4' },
    { :email => 'user5@example.com', :name => 'User Five', :password_digest => 'password5' }
  ]

  more_create_accounts.each do |create_account|
    CreateAccounts.create!(create_account)
  end
