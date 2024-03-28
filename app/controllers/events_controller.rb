# frozen_string_literal: true

require 'csv'
require 'roo'
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
  def edit
    return unless @event.time_slots.present?

    render 'series_event'
  end

  # POST /events or /events.json
  def create
    name = event_params[:name]
    venue = event_params[:venue]
    date = event_params[:date]
    csv_file = event_params[:csv_file]
    start_time = event_params[:start_time]
    end_time = event_params[:end_time]
    max_capacity = event_params[:max_capacity]
    reminder_time = event_params[:reminder_time]

    date = Time.now if date.nil?

    @event = Event.new(
      name:
    )
    @event_info = EventInfo.new(
      name:,
      venue:,
      date:,
      start_time:,
      end_time:,
      reminder_time:,
      max_capacity:
    )

    if csv_file.present? && File.extname(csv_file.path) == '.csv'
      @event.csv_file.attach(csv_file)
      # Parse the CSV data
      csv_data = csv_file.read
      parsed_data = CSV.parse(csv_data, headers: true)
    elsif csv_file.present? && File.extname(csv_file.path) == '.xlsx'
      excel_data = csv_file.read
      workbook = Roo::Excelx.new(StringIO.new(excel_data))
      worksheet = workbook.sheet(0) # Assuming the data is in the first sheet
      headers = worksheet.row(1) # Assuming headers are in the first row
      parsed_data = []
      (2..worksheet.last_row).each do |i| # Start from the second row
        row = Hash[[headers, worksheet.row(i)].transpose]
        parsed_data << row
      end
    end

    # NOTE: @event.id does not exist until the record is SAVED

    respond_to do |format|
      if @event.save

        # Create time_slot data if applicable
        @event.update(event_params.extract!(:time_slots_attributes))

        # Save the other events reference to the event
        # ---------------------- Make this a separate function ------------------- #
        if parsed_data.nil?
          # Handle the case when parsed_data is nil
          puts 'parsed_data is nil'
        elsif parsed_data.empty?
          puts 'parsed_data is empty'
        # Handle the case when parsed_data is an empty array
        else
          parsed_data.each do |row|
            email = row['Email']
            priority = row['Priority']

            @attendee = AttendeeInfo.new(
              email:,
              event_id: @event.id,
              email_token: SecureRandom.uuid,
              priority:
            )
            puts "Validation errors: #{@attendee.errors.full_messages}" unless @attendee.save
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
    event_params[:date]
    event_params[:start_time]
    event_params[:end_time]
    event_params[:max_capacity]
    event_params[:reminder_time]
    event_params[:csv_file]

    event_info = @event.event_info

    respond_to do |format|
      if @event.time_slots.present? && @event.update(event_params.extract!(:name,
                                                                           :time_slots_attributes)) && event_info.update(
                                                                             name:, venue:
                                                                           )
        format.html { redirect_to event_url(@event), notice: 'Event was successfully updated.' }
        format.json { render :show, status: :ok, location: @event }
      elsif @event.update(name:) && event_info.update(event_params.except(:csv_file, :time_slots))
        format.html { redirect_to event_url(@event), notice: 'Event was successfully updated.' }
        format.json { render :show, status: :ok, location: @event }
      else
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

  def yes_response_series
    @event = Event.find(params[:id])
    @time_slot = TimeSlot.find(params[:time_slot])
    @attendee_info = @event.attendee_infos.find_by(email_token: params[:token])

    # If any of the data doesn't exist then return
    if !@event.present? || !@time_slot.present? || !@attendee_info.present?
      redirect_to event_url(@event), notice: 'Invalid Response Params'
      return
    end

    # Does the time_slot already belong to someone?
    unless @time_slot.attendee_info.nil?
      redirect_to event_url(@event), notice: 'Time-slot has already been selected, Please select another one'
      return
    end

    # Does the attendee already have a time_slot? We need to decide what to do about this but for now deny it
    if @attendee_info.time_slot.present?
      redirect_to event_url(@event),
                  notice: 'You have already selected a time-slot, Please contact admin to change selected time'
      return
    end

    # Good path, time_slot doesn't belong to anyone and attendee doesn't already have a time_slot they have selected
    @attendee_info.update!(is_attending: 'yes')
    @time_slot.update!(attendee_info_id: @attendee_info.id)

    redirect_to event_url(@event), notice: 'Your response has been recorded'
  end

  def yes_response
    @event = Event.find(params[:id])
    @attendee_info = @event.attendee_infos.find_by(email_token: params[:token])

    @attendee_info.update(is_attending: 'yes') if @event.present? && @attendee_info.present?

    redirect_to event_url(@event), notice: 'Your response has been recorded'
  end

  def no_response
    @event = Event.find(params[:id])
    @attendee_info = @event.attendee_infos.find_by(email_token: params[:token])

    @attendee_info.update(is_attending: 'no') if @event.present? && @attendee_info.present?

    # Find the next attendee who hasn't responded yet and is not at max capacity
    next_attendee = @event.attendee_infos.where(email_sent: false).where.not(id: attendees_at_or_over_capacity).first

    if next_attendee.present?
      EventRemainderMailer.with(email: next_attendee.email, token: next_attendee.email_token,
                                event: @event).reminder_email.deliver
      next_attendee.update(email_sent: true)
      next_attendee.update(email_sent_time: DateTime.now)
    end
    redirect_to event_url(@event), notice: 'Your response has been recorded'
  end

  def attendees_at_or_over_capacity
    @event = Event.find(params[:id])
    @event_info = @event.event_info
    max_capacity = @event_info.max_capacity
    @event.attendee_infos.where(is_attending: %w[yes no],
                                email_sent: true).limit(max_capacity)
  end

  def invite_attendees
    @event = Event.find(params[:id])
    @event_info = @event.event_info

    yes_attendees = @event.attendee_infos.where(is_attending: 'yes')

    if @event_info.max_capacity.present? && @event_info.max_capacity != yes_attendees.count

      attendees_to_invite = @event.attendee_infos.where(email_sent: false).limit(@event_info.max_capacity)
      attendees_to_invite.each do |attendee|
        EventRemainderMailer.with(email: attendee.email, token: attendee.email_token,
                                  event: @event).reminder_email.deliver
        attendee.update(email_sent: true)
        attendee.update(email_sent_time: DateTime.now)
      end
    elsif !@event_info.max_capacity.present?
      @event.attendee_infos.where(email_sent: false).each do |attendee|
        EventRemainderMailer.with(email: attendee.email, token: attendee.email_token,
                                  event: @event).reminder_email.deliver
        attendee.update(email_sent: true)
        attendee.update(email_sent_time: DateTime.now)
      end
    end
    redirect_to eventsList_path
  end

  def send_reminders_to_attendees
    @event = Event.find(params[:id])
    @event_info = @event.event_info

    # Find attendees who responded "yes"
    yes_attendees = @event.attendee_infos.where(is_attending: 'yes')

    # Send emails to those attendees who have already responded "yes"
    yes_attendees.each do |attendee|
      EventRemainderMailer.with(email: attendee.email, token: attendee.email_token,
                                event: @event).event_reminder.deliver
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
    params.require(:event).permit(:name, :venue, :date, :start_time, :end_time, :max_capacity, :reminder_time,
                                  :csv_file, time_slots_attributes: %i[id date start_time end_time _destroy])
  end
end
