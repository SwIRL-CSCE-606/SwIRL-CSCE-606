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

  # GET /events/1/edit
  def edit; end

  # POST /events or /events.json
  def create
    name = event_params[:name]
    venue = event_params[:venue]
    date = event_params[:date]
    time = event_params[:time]
    email = event_params[:email]

    @event = Event.new(
      name:       name
    )
    @event_info = EventInfo.new(
      name:       name,
      venue:      venue,
      date:       date,
      time:       time
    )

    # Make this loop through list instead (once we can retrieve a list from the form)
    @attendee = AttendeeInfo.new(
      email:      email,
    )

    # NOTE: @event.id does not exist until the record is SAVED

    respond_to do |format|
      if @event.save
        # Save the other events reference to the event
        @event_info.event_id = @event.id
        @attendee.event_id = @event.id

        if @event_info.save && @attendee.save
          @event.update(event_info_id: @event_info.id)
          format.html do
            redirect_to event_url(@event), notice: 'Event was successfully created.'
            EventRemainderMailer.with(email: @attendee.email).remainder_email.deliver_now
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
    time = event_params[:time]
    email = event_params[:email]

    event_info = EventInfo.find_by(id: @event.event_info.id)

    respond_to do |format|
      if @event.update(name: name) && event_info.update(name: name, venue: venue, date: date, time:time)
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
    # Creating a dummy @event
    # Dummy event data
    @events = [
        OpenStruct.new({
            id: 1,
            name: "Sample Event 1",
            description: "This is a sample event",
            date: Date.today,
            time: Time.now,
            location: "Sample Location 1",
            yes_count: 50,
            no_count: 20
        }),
        OpenStruct.new({
            id: 2,
            name: "Sample Event 2",
            description: "This is another sample event",
            date: Date.today + 1.day,
            time: Time.now + 1.hour,
            location: "Sample Location 2",
            yes_count: 30,
            no_count: 40
        })
    ]

    # Dummy attendees data
    @attendees = [
      OpenStruct.new(status: 'Yes', name: 'John Doe'),
      OpenStruct.new(status: 'No', name: 'Jane Smith'),
      OpenStruct.new(status: 'Yes', name: 'Charlie Brown')
    ]

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
    @event = Event.includes(:event_information).find(params[:id]) # You can fetch the event by ID or however you want
    render 'email_invitation'
  end

  private

  # Use callbacks to share common setup or constraints between actions.
  def set_event
    @event = Event.find(params[:id])
  end

  # Only allow a list of trusted parameters through.
  def event_params
    params.require(:event).permit(:name, :venue, :date, :time, :email)
  end
end
