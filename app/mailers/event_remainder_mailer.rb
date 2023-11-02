require 'csv'

class EventRemainderMailer < ApplicationMailer
    default from: 'noreply@sendgrid.net'
    default_url_options[:host] = 'https://skhedule-9d55cf93012e.herokuapp.com'

    def remainder_email(csv_file_path)
        @url = 'https://skhedule-9d55cf93012e.herokuapp.com/'
    
        
        if csv_file_path.present?
          # Create an email for each recipient in the CSV file
          CSV.foreach(csv_file_path, headers: true) do |row|
            email = row['email'] # Assuming 'email' is a column in your CSV

            mail(to: email, subject: 'Email Reminder').deliver # Use deliver here, not deliver_now
          end
        end
      end

    def reminder_email
        @email = params[:email]
        @url = 'https://skhedule-9d55cf93012e.herokuapp.com'
        @event = params[:event]
        @token = params[:token]
        mail(to: @email, subject: 'Email Remainder', template_name: 'email_invitation')
    end
 
end




