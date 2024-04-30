# frozen_string_literal: true

# app/helpers/events_helper.rb

module EventsHelper
    def readable_status(status)
        case status
        when 'awaiting_reply'
          'Invitation sent - awaiting reply'
        when 'replied_attending'
          'Replied - attending'
        when 'replied_not_attending'
          'Replied - not attending'
        else
          'Unknown Status'
        end
      end
    
      def status_class(status)
        case status
        when 'awaiting_reply'
          'status-awaiting-reply'
        when 'replied_attending'
          'status-attending'
        when 'replied_not_attending'
          'status-not-attending'
        else
          'status-unknown' # Optionally handle unknown or default cases
        end
      end
  end