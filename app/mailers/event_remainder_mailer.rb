class EventRemainderMailer < ApplicationMailer
    default from: 'noreply@sendgrid.net'

    def remainder_email
        @email = params[:email]
        @url = 'https://skhedule-9d55cf93012e.herokuapp.com/'
        mail(to: @email, subject: 'Email Remainder')
    end
end




