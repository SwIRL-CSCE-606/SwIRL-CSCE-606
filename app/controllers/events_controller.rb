
require 'csv'
require 'securerandom'


class EventsController < ApplicationController
  before_action :set_event, only: %i[show edit update destroy]

  # GET /events/1 or /events/1.json
  def show; end

  # GET /events/new
  def new
    @event = Event.new
    # Create EventInfothat corresponds to Event
    @event_info = EventInfo.new
  end

  # GET /events/1/edit
  def edit; end

  # POST /events or /events.json
  def create
    name = event_params[:name]
    venue = event_params[:venue]
    date = event_params[:date]
    csv_file = event_params[:csv_file]
    start_time = event_params[:start_time]
    end_time = event_params[:end_time]
    max_capacity = event_params[:max_capacity]
    time_slots = event_params[:time_slot]

    if date.nil?
      date = Time.now
    end

    @event = Event.new(
      name:       name
    )
    @event_info = EventInfo.new(
      name:         name,
      venue:        venue,
      date:         date,
      start_time:   start_time,
      end_time:     end_time,
      max_capacity: max_capacity
    )

    if csv_file.present?
      @event.csv_file.attach(csv_file)
      # Parse the CSV data
      csv_data = csv_file.read
      parsed_data = CSV.parse(csv_data, headers: true)
    end

    # NOTE: @event.id does not exist until the record is SAVED

    respond_to do |format|
      if @event.save

        # Create time_slot data if applicable 
        if not time_slots.nil?
          time_slots.each do |time_slot_data|
            time_slot = TimeSlot.create!(
              date: time_slot_data[:date],
              start_time: time_slot_data[:start_time],
              end_time: time_slot_data[:end_time],
              event_id: @event.id 
            )
          end
        end

        # Save the other events reference to the event
        # ---------------------- Make this a separate function ------------------- #
        if parsed_data.nil?
          # Handle the case when parsed_data is nil
          puts "parsed_data is nil"
        else
          if parsed_data.empty?
            # Handle the case when parsed_data is an empty array
            puts "parsed_data is empty"
          else
            parsed_data.each do |row|
              email = row["Email"]
              priority = row["Priority"]
        
              @attendee = AttendeeInfo.new(
                email: email,
                event_id: @event.id,
                email_token: SecureRandom.uuid,
                priority: priority,
              )
              unless @attendee.save
                puts "Validation errors: #{@attendee.errors.full_messages}"
              end
            end
          end
        end
        # ----------------------------------------------------------------------- #
        @event_info.event_id = @event.id
  
        if @event_info.save
          format.html do
            redirect_to event_url(@event), notice: 'Event was successfully created.'
          end
        end
      else
        format.html { render :new, status: :unprocessable_entity }
        format.json { render json: @event.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /events/1 or /events/1.json
  def update
    name = event_params[:name]
    venue = event_params[:venue]
    date = event_params[:date]
    start_time = event_params[:start_time]
    end_time = event_params[:end_time]
    max_capacity = event_params[:max_capacity]
    # email = event_params[:email]
    event_info = @event.event_info

    respond_to do |format|
      if @event.update(name: name) && event_info.update(name: name, venue: venue, max_capacity: max_capacity, date: date, start_time: start_time, end_time: end_time)
          format.html { redirect_to event_url(@event), notice: 'Event was successfully updated.' }
          format.json { render :show, status: :ok, location: @event }
      else
        logger.debug @event.errors.full_messages
        logger.debug event_info.errors.full_messages
        format.html { render :edit, status: :unprocessable_entity }
        format.json { render json: @event.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /events/1 or /events/1.json
  def destroy
    @event.destroy

    respond_to do |format|
      format.html { redirect_to events_url, notice: 'Event was successfully destroyed.' }
      format.json { head :no_content }
    end
  end

  def event_status
    @events = Event.all
  end

  def yes_response
    @event = Event.find(params[:id])
    @attendee_info = @event.attendee_infos.find_by(email_token: params[:token])

    if @event.present? && @attendee_info.present?
      @attendee_info.update(is_attending: "yes")
    end
    
    redirect_to event_url(@event), notice: 'Your response has been recorded'
  end

  def no_response
    @event = Event.find(params[:id])
    @attendee_info = @event.attendee_infos.find_by(email_token: params[:token])

    if @event.present? && @attendee_info.present?
      @attendee_info.update(is_attending: "no")
    end

    # Find the next attendee who hasn't responded yet and is not at max capacity
    next_attendee = @event.attendee_infos.where(email_sent: false).where.not(id: attendees_at_or_over_capacity).first

    if next_attendee.present?
      EventRemainderMailer.with(email: next_attendee.email, token: next_attendee.email_token, event: @event).reminder_email.deliver
      next_attendee.update(email_sent: true)
      next_attendee.update(email_sent_time: DateTime.now)
    end
    redirect_to event_url(@event), notice: 'Your response has been recorded'
  end

  def attendees_at_or_over_capacity
    @event = Event.find(params[:id])
    @event_info = @event.event_info
    max_capacity = @event_info.max_capacity
    attendees_at_capacity = @event.attendee_infos.where(is_attending: ["yes", "no"], email_sent: true).limit(max_capacity)
    attendees_at_capacity
  end

  

  def invite_attendees
    @event = Event.find(params[:id])
    @event_info = @event.event_info

    if @event_info.max_capacity.present?
      attendees_to_invite = @event.attendee_infos.where(email_sent: false).limit(@event_info.max_capacity)
      attendees_to_invite.each do |attendee|
        EventRemainderMailer.with(email: attendee.email, token: attendee.email_token, event: @event).reminder_email.deliver
        attendee.update(email_sent: true)
        attendee.update(email_sent_time: DateTime.now)
      end
    else
      @event.attendee_infos.where(email_sent: false).each do |attendee|
        EventRemainderMailer.with(email: attendee.email, token: attendee.email_token, event: @event).reminder_email.deliver
        attendee.update(email_sent: true)
        attendee.update(email_sent_time: DateTime.now)
      end
    end
    redirect_to eventsList_path
  end


  def series_event
    @event = Event.new
    @event_info = EventInfo.new
    @event.time_slots.build
  end

  private

  # Use callbacks to share common setup or constraints between actions.
  def set_event
    @event = Event.find(params[:id])
  end

  # Only allow a list of trusted parameters through.
  def event_params
    params.require(:event).permit(:name, :venue, :date, :start_time, :end_time, :max_capacity, :csv_file, time_slot: [:date, :start_time, :end_time])

  end

  def send_reminders_to_attendees
    # Find attendees who responded "yes"
    yes_attendees = self.attendee_infos.where(is_attending: "yes")

    # Send reminders to attendees at 8 am of the previous day
    yes_attendees.each do |attendee|
      reminder_time = self.date.to_datetime.change({ hour: 8, min: 0, sec: 0 })

      # Check if the current time is after the reminder time
      if DateTime.now >= reminder_time
        # Send reminder email to attendee
        EventRemainderMailer.with(email: attendee.email, token: attendee.email_token, event: self).reminder_email.deliver

      end
    end
  end

  def self.send_email_reminders
    # Find events scheduled for the next day
    events_scheduled_for_next_day = Event.where(date: Date.tomorrow.beginning_of_day..Date.tomorrow.end_of_day)

    # Iterate through those events and send reminders to attendees who responded "yes"
    events_scheduled_for_next_day.each do |event|
      event.send_reminders_to_attendees
    end
  end
end
