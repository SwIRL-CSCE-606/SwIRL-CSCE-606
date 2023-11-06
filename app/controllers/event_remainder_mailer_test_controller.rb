class EventRemainderMailerTestController < ApplicationController
    def email_invitation
        # Add any setup code here if necessary, for instance setting instance variables.
        render 'event_remainder_mailer/email_invitation'
    end
    
end
