class CalendarsController < ApplicationController
    def redirect
        client = Signet::OAuth2::Client.new(client_options)
        puts client.authorization_uri.to_s
        redirect_to(client.authorization_uri.to_s, allow_other_host: true)
    end

    def callback
        client = Signet::OAuth2::Client.new(client_options)
        client.code = params[:code]
    
        response = client.fetch_access_token!
    
        session[:authorization] = response
    
        redirect_to calendars_url
    end

    def calendars
        client = Signet::OAuth2::Client.new(client_options)
        client.update!(session[:authorization])
    
        service = Google::Apis::CalendarV3::CalendarService.new
        service.authorization = client
    
        @calendar_list = service.list_calendar_lists
    end

    private

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
