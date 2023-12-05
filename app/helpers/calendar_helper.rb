# app/helpers/calendar_helper.rb
module CalendarHelper
    def generate_icalendar(event, from_email, request_method: 'REQUEST')
      <<~ICAL
        BEGIN:VCALENDAR
        VERSION:2.0
        PRODID:-//example.com//NONSGML Example//EN
        BEGIN:VEVENT
        SUMMARY:#{event.name}
        DTSTART:#{event.event_info.date.strftime('%Y%m%dT') + event.event_info.start_time.strftime('%H%M%S')}
        DTEND:#{event.event_info.date.strftime('%Y%m%dT') + event.event_info.end_time.strftime('%H%M%S')}
        LOCATION:#{event.event_info.venue}
        DESCRIPTION:""
        ORGANIZER:mailto:#{from_email} # Replace with the actual organizer's email
        SEQUENCE:0
        STATUS:CONFIRMED
        METHOD:#{request_method}
        END:VEVENT
        END:VCALENDAR
        ICAL
    end
  end