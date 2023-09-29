class EventRemainderMailer < ApplicationMailer
    default from: 'no-reply@skhedule.com'

    def remainder_email
        @url = 'https://skhedule-9d55cf93012e.herokuapp.com/'
        mail(to: params[:email], subject: 'Email Remainder')
    end
end
