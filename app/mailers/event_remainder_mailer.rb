include Rails.application.routes.url_helpers

class EventRemainderMailer < ApplicationMailer
    default from: 'noreply@sendgrid.net'
    default_url_options[:host] = 'https://skhedule-9d55cf93012e.herokuapp.com'
    

    def remainder_email
        @email = params[:email]
        @url = 'https://skhedule-9d55cf93012e.herokuapp.com'
        @event = params[:event]
        @token = params[:token]
        mail(to: @email, subject: 'Email Remainder', template_name: 'email_invitation')
    end
end




