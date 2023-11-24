# lib/tasks/email_reminders.rake

desc "Send email reminders for upcoming events"
task :send_email_reminders => :environment do
  Event.send_email_reminders
end
