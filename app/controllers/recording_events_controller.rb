class RecordingEventsController < ApplicationController
  # GET /recording_events
  # GET /recording_events.json
  def index
    @recording_events = RecordingEvent.all

    respond_to do |format|
      format.html # index.html.erb
      format.json { render json: @recording_events }
    end
  end

  # GET /recording_events/1
  # GET /recording_events/1.json
  def show
    @recording_event = RecordingEvent.find(params[:id])

    respond_to do |format|
      format.html # show.html.erb
      format.json { render json: @recording_event }
    end
  end

  # GET /recording_events/new
  # GET /recording_events/new.json
  def new
    @recording_event = RecordingEvent.new

    respond_to do |format|
      format.html # new.html.erb
      format.json { render json: @recording_event }
    end
  end

  # GET /recording_events/1/edit
  def edit
    @recording_event = RecordingEvent.find(params[:id])
  end

  # POST /recording_events
  # POST /recording_events.json
  def create
    @recording_event = RecordingEvent.new(params[:recording_event])

    respond_to do |format|
      if @recording_event.save
        format.html { redirect_to @recording_event, notice: 'Recording event was successfully created.' }
        format.json { render json: @recording_event, status: :created, location: @recording_event }
      else
        format.html { render action: "new" }
        format.json { render json: @recording_event.errors, status: :unprocessable_entity }
      end
    end
  end

  # PUT /recording_events/1
  # PUT /recording_events/1.json
  def update
    @recording_event = RecordingEvent.find(params[:id])

    respond_to do |format|
      if @recording_event.update_attributes(params[:recording_event])
        format.html { redirect_to @recording_event, notice: 'Recording event was successfully updated.' }
        format.json { head :no_content }
      else
        format.html { render action: "edit" }
        format.json { render json: @recording_event.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /recording_events/1
  # DELETE /recording_events/1.json
  def destroy
    @recording_event = RecordingEvent.find(params[:id])
    @recording_event.destroy

    respond_to do |format|
      format.html { redirect_to recording_events_url }
      format.json { head :no_content }
    end
  end
end
