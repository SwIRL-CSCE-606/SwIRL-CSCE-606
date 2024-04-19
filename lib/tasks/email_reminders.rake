# frozen_string_literal: true

# lib/tasks/email_reminders.rake

namespace :reminders do
  desc 'Send remidner emails to everyone who has been invited'
  task :send_reminders_to_attendees => :environment do
    EventsController.new.send_reminders_to_attendees
  end

  desc "Send reminder eamils to everyone who has not yet respnoded"
  task :send_no_response_reminders => :environment do
    EventsController.new.send_reminders_to_no_response_attendees
  end
end