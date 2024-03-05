class CalendarsController < ApplicationController
    def redirect
        client = Signet::OAuth2::Client.new(client_options)
        redirect_to(client.authorization_uri.to_s, allow_other_host: true)
    end

    def callback
        client = Signet::OAuth2::Client.new(client_options)
        client.code = params[:code]
    
        response = client.fetch_access_token!
    
        session[:authorization] = response
    
        redirect_to eventsList_url
    end

    def create_event
        if authorized?
            begin
                client = Signet::OAuth2::Client.new(client_options)
                client.update!(session[:authorization])
            
                service = Google::Apis::CalendarV3::CalendarService.new
                service.authorization = client

                today = Date.today
                
                # location, attendees
                new_event = Google::Apis::CalendarV3::Event.new(
                start: Google::Apis::CalendarV3::EventDateTime.new(date: today),
                end: Google::Apis::CalendarV3::EventDateTime.new(date: today + 1),
                summary: 'New event!'
                )
                calendar_id = params[:calendar_id] || 'primary'
                service.insert_event(calendar_id, new_event)

                flash[:notice] = 'Event added successfully!'
            
                redirect_to eventsList_url

            rescue => e
                flash[:alert] = 'Failed to add event!'
                redirect_to eventsList_url
            end
        
        else 
            redirect_to redirect_path
            return
        end
    end

    private

    def authorized?
        session[:authorization].present? 
    end

    def client_options
        {
          client_id: "54273617703-87bsbouu3r31ga09apt4ihqs8pli2v0c.apps.googleusercontent.com",
          client_secret: "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",
          authorization_uri: "https://accounts.google.com/o/oauth2/auth",
          token_credential_uri: "https://oauth2.googleapis.com/token",
          scope: Google::Apis::CalendarV3::AUTH_CALENDAR,
          redirect_uri: callback_url
        }
    end
end
