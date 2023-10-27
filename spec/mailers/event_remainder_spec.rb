# require "rails_helper"

# RSpec.describe EventRemainderMailer, type: :mailer do
#   # Test if emails can be sent (not checking content)
#   it "send a email" do
#     email = "test@example.com"
    
#     expect {
#       EventRemainderMailer.with(email: email).remainder_email.deliver_now
#     }.to change {ActionMailer::Base.deliveries.count}.by(1)
#   end
# end


# require "rails_helper"



require "rails_helper"
require 'tempfile'
require 'csv'

RSpec.describe EventRemainderMailer, type: :mailer do
  it "sends emails from a CSV file" do
    # Set up a CSV file with email addresses for testing
    csv_data = <<~CSV
      email
      aashaykadakia@gmail.com
      aashaykadakia@tamu.edu
    CSV

    # Create a temporary CSV file for testing
    csv_file = Tempfile.new('test_emails.csv')
    csv_file.write(csv_data)
    csv_file.rewind

    # Create an instance of the mailer and pass the csv_file_path as an argument
    mailer = EventRemainderMailer.with(csv_file: csv_file.path).remainder_email(csv_file.path)

    expect {
      mailer.deliver
    }.to change { ActionMailer::Base.deliveries.count }.by(3) # Change this number based on the number of email addresses in your CSV
  end
end



