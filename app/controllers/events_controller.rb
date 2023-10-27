
require 'csv'
require 'securerandom'


class EventsController < ApplicationController
  before_action :set_event, only: %i[show edit update destroy]

  # GET /events or /events.json
  def index
    @events = Event.all
  end

  # GET /events/1 or /events/1.json
  def show; end

  # GET /events/new
  def new
    @event = Event.new
    # Create EventInfothat corresponds to Event
    @event_info = EventInfo.new
  end

  def event_dashboard
      render template eventdashboard
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
    email = event_params[:email]


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

    # Make this loop through list instead (once we can retrieve a list from the form)
    @attendee = AttendeeInfo.new(
      email:        email,
      email_token:  SecureRandom.uuid
    )

    #@email = something something parse through csv here to get list of attendees

    #commented the above code because that was entering a textbox for the email
    #below is uploading a csv
    if csv_file.present?
      @event.csv_file.attach(csv_file)
      # Parse the CSV data
      csv_data = csv_file.read
      parsed_data = CSV.parse(csv_data, headers: true)
    end

    # NOTE: @event.id does not exist until the record is SAVED

    respond_to do |format|
      if @event.save
        # Save the other events reference to the event    
        parsed_data.each do |row|
          email = row["Email"]
      
          @attendee = AttendeeInfo.new(
            email: email,
            event_id: @event.id,
          )
          puts "Parsed Data: #{parsed_data}"
          unless @attendee.save
            puts "Validation errors: #{@attendee.errors.full_messages}"
          end
        end
        @event_info.event_id = @event.id
        # need to do something here instead to store csv 
        @attendee.event_id = @event.id

        if @event_info.save && @attendee.save
          @event.update(event_info_id: @event_info.id)
          format.html do
            redirect_to event_url(@event), notice: 'Event was successfully created.'
            EventRemainderMailer.with(email: email, token: @attendee.email_token, event: @event).remainder_email.deliver_now
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

    event_info = EventInfo.find_by(id: @event.event_info.id)

    respond_to do |format|
      if @event.update(name: name) && event_info.update(name: name, venue: venue, date: date, start_time:start_time)
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
    @events = Event.includes(:attendee_infos, :event_info).all

    # # Grabbing data from the database
    # @event.name = @event.name
    # @event.description = @event.duration
    # @event.date = @event.created_at.to_date
    # @event.time = @event.start_time
    # @event.location = 'Your Location Here' # Placeholder since location isn't provided

    # # Calculate the invite status
    # attending_count = @attendees.select { |attendee| attendee.status == 'Yes' }.count
    # not_attending_count = @attendees.count - attending_count

    # @event.yes_count = attending_count
    # @event.no_count = not_attending_count

    # # Calculate the ratios
    # @event.yes_ratio = (attending_count.to_f / @attendees.count) * 100
    # @event.no_ratio = 100 - @event.yes_ratio
  end

  def email_invitation
    @event = Event.includes(:event_info).find(params[:id]) # You can fetch the event by ID or however you want
    render 'email_invitation'
  end

  def yes_response
    @event = Event.find_by(params[:id])
    @attendee_info = Event.attendee_infos.find_by(email_token: params[:token])

    if @event.present? && @attendee_info.present?
      @attendee_info.is_attending = 1
      @attendee_info.update
    end
    show
  end

  def no_response
    @event = Event.find_by(params[:id])
    @attendee_info = Event.attendee_infos.find_by(email_token: params[:token])

    if @event.present? && @attendee_info.present?
      @attendee_info.is_attending = 0
      @attendee_info.update
    end
    show
  end
  

  private

  # Use callbacks to share common setup or constraints between actions.
  def set_event
    @event = Event.find(params[:id])
  end

  # Only allow a list of trusted parameters through.
  def event_params
    params.require(:event).permit(:name, :venue, :date, :start_time, :end_time, :max_capacity, :csv_file, :email)

  end
end
