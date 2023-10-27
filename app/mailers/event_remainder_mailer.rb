require 'csv'

class EventRemainderMailer < ApplicationMailer
    default from: 'noreply@sendgrid.net'

    # def remainder_email
    #     #@email = params[:email]
    #     @url = 'https://skhedule-9d55cf93012e.herokuapp.com/'
    #     mail(to: @email, subject: 'Email Remainder')
    # end

    # def remainder_email
    #     @url = 'https://skhedule-9d55cf93012e.herokuapp.com/'
      
    #     # Assuming you've stored the path to the CSV file in an instance variable
    #     @csv_file = params[:csv_file]
    #     csv_file_path = @csv_file
        
    #     # Parse the CSV file and extract email addresses
    #     CSV.foreach(csv_file_path, headers: true) do |row|
    #       email = row['email'] # Assuming 'email' is a column in your CSV
    #       mail(to: email, subject: 'Email Reminder').deliver_now
    #     end
    #   end

    def remainder_email(csv_file_path)
        @url = 'https://skhedule-9d55cf93012e.herokuapp.com/'
    
        
        if csv_file_path.present?
          # Create an email for each recipient in the CSV file
          CSV.foreach(csv_file_path, headers: true) do |row|
            email = row['email'] # Assuming 'email' is a column in your CSV
            # Add debugging output

            puts "Email extracted from CSV: #{email}"

            mail(to: email, subject: 'Email Reminder').deliver # Use deliver here, not deliver_now
          end
        end
      end
end




