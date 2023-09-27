class EventRemainderMailer < ApplicationMailer
    default from: 'no-reply@skhedule.com'

    def remainder_email
        @user = params[:user]
        @url = 'https://skhedule-9d55cf93012e.herokuapp.com/'
        mail(to: @user.email, subject: 'Email Remainder')
    end
end
