class EventSourcesController < ApplicationController
  load_and_authorize_resource

  # GET /event_sources
  # GET /event_sources.json
  def index
    @event_sources = EventSource.all

    respond_to do |format|
      format.html # index.html.erb
      format.json { render :json => @event_sources }
    end
  end

  # GET /event_sources/1
  # GET /event_sources/1.json
  def show
    @event_source = EventSource.find(params[:id])

    respond_to do |format|
      format.html # show.html.erb
      format.json { render :json => @event_source }
    end
  end

  # GET /event_sources/new
  # GET /event_sources/new.json
  def new
    @event_source = EventSource.new

    respond_to do |format|
      format.html # new.html.erb
      format.json { render :json => @event_source }
    end
  end

  # GET /event_sources/1/edit
  def edit
    @event_source = EventSource.find(params[:id])
  end

  # POST /event_sources
  # POST /event_sources.json
  def create
    @event_source = EventSource.new(params[:event_source])

    respond_to do |format|
      if @event_source.save
        format.html { redirect_to @event_source, :notice => 'Event source was successfully created.' }
        format.json { render :json => @event_source, :status => :created, :location => @event_source }
      else
        format.html { render :action => "new" }
        format.json { render :json => @event_source.errors, :status => :unprocessable_entity }
      end
    end
  end

  # PUT /event_sources/1
  # PUT /event_sources/1.json
  def update
    @event_source = EventSource.find(params[:id])

    respond_to do |format|
      if @event_source.update_attributes(params[:event_source])
        format.html { redirect_to @event_source, :notice => 'Event source was successfully updated.' }
        format.json { head :no_content }
      else
        format.html { render :action => "edit" }
        format.json { render :json => @event_source.errors, :status => :unprocessable_entity }
      end
    end
  end

  # DELETE /event_sources/1
  # DELETE /event_sources/1.json
  def destroy
    @event_source = EventSource.find(params[:id])
    @event_source.destroy

    respond_to do |format|
      format.html { redirect_to event_sources_url }
      format.json { head :no_content }
    end
  end

  def load_events
    @event_source = EventSource.find(params[:id])

    @event_source.reload_events!(@api)

    redirect_to event_sources_path
  end
end
