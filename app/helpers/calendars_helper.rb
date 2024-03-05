module CalendarsHelper
    def new_event(event)
        client = Signet::OAuth2::Client.new(client_options)
        client.update!(session[:authorization])
    
        service = Google::Apis::CalendarV3::CalendarService.new
        service.authorization = client
    
        today = Date.today
        
        # location, attendees
        event = Google::Apis::CalendarV3::Event.new({
          start: Google::Apis::CalendarV3::EventDateTime.new(date: today),
          end: Google::Apis::CalendarV3::EventDateTime.new(date: today + 1),
          summary: 'New event!'
        })
    
        service.insert_event(params[:calendar_id], event)
    
        redirect_to events_url(calendar_id: params[:calendar_id])
    end
end
