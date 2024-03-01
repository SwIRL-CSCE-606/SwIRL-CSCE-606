require 'csv'
require 'roo'
require 'active_support/all'
include CalendarHelper

class EventRemainderMailer < ApplicationMailer
    default from: 'skhedule4@gmail.com'
    default_url_options[:host] = 'https://swirlskehdule-f316b598c688.herokuapp.com/'

    def remainder_email(csv_file_path)
      @url = 'https://swirlskehdule-f316b598c688.herokuapp.com/'
      if csv_file_path.present?
        if File.extname(csv_file_path) == '.csv'
          # Create an email for each recipient in the CSV file
          CSV.foreach(csv_file_path, headers: true) do |row|
            email = row['email'] # Assuming 'email' is a column in your CSV

            mail(to: email, subject: 'Email Invitation').deliver # Use deliver here, not deliver_now
          end
        elsif File.extname(csv_file_path) == '.xlsx'
          workbook = Roo::Excelx.new(csv_file_path)
          column_1_data = workbook.column(1)
          column_1_data.each do |value|
            mail(to: value, subject: 'Email Invitation').deliver # Use deliver here, not deliver_now
          end
        else
          puts "Unsupported File Type"
        end
      end
    end
    
    def reminder_email
        @email = params[:email]
        @url = 'https://swirlskehdule-f316b598c688.herokuapp.com/'
        @event = params[:event]
        @token = params[:token]
        
        # Render specific email based on if event has time_slots (which implies it is a series event)
        if @event.time_slots.present?
          mail(to: @email, subject: 'Speaker Event Invitation', template_name: 'email_invitation_series')
        else
          icalendar_content = generate_icalendar(@event, default_params[:from])
          mail(to: @email, subject: 'Event Invitation', template_name: 'email_invitation') do |format|
            # format.ics { render plain: icalendar_content }
            attachments['event.ics'] = { mime_type: 'text/calendar', content: icalendar_content }
            format.html
          end
        end
    end

    
    def event_reminder
      @email = params[:email]
      @url = 'https://swirlskehdule-f316b598c688.herokuapp.com/'
      @event = params[:event]
      @token = params[:token]
      mail(to: @email, subject: 'Event Reminder', template_name: 'event_reminder')        
    end
end




