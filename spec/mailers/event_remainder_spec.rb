require "rails_helper"

RSpec.describe EventRemainderMailer, type: :mailer do
  # Test if emails can be sent (not checking content)
  it "send a email" do
    email = "test@example.com"
    
    expect {
      EventRemainderMailer.with(email: email).remainder_email.deliver_now
    }.to change {ActionMailer::Base.deliveries.count}.by(1)
  end
end
