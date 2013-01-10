class EventsController < ApplicationController
  before_filter :load_event, :except => [:index, :home]

  # GET /events
  # GET /events.json
  def index
    authorize!(:index, Event)
    @events = Event.all.sort do |a, b|
      b.time_start <=> a.time_start
    end
    
    respond_to do |format|
      format.html # index.html.erb
      format.json { render :json => @events }
    end
  end

  def home
    authorize!(:home, Event)
    @upcoming_events = []
    @past_events = []
    
    events = Event.where(:hidden => false).sort do |a, b|
      a.time_end <=> b.time_end
    end
    
    now = Time.new
    events.each do |e|
      if e.time_end > now
        @upcoming_events.push e
      else
        @past_events.push e
      end
    end

    @past_events.reverse!

    respond_to do |format|
      format.html # index.html.erb
      format.json { render :json => {:upcoming => @upcoming_events, :past => @past_events } }
    end
  end

  # GET /events/1
  # GET /events/1.json
  def show
    @hack = Hack.new(flash[:hack])

    if @current_user.id?
      my_hack_ids = @current_user.hack_ids & @event.hack_ids
      @my_hacks = Hack.where(:id => my_hack_ids)
    end

    respond_to do |format|
      format.html # show.html.erb
      format.json { render :json => @event }
    end
  end

  def raffle
    @entries = @event.raffle_eligible_users(@api).sort do |a, b|
      a.fbid <=> b.fbid
    end
    
    @winner = @entries.shuffle.pop
  end

  def order
    @hacks = @event.hacks_completed.sort do |a, b|
      b.sort_rand <=> a.sort_rand
    end
  end

  def toggle_hidden
    @event.hidden = !@event.hidden
    @event.save!

    respond_to do |format|
      format.html { redirect_to events_path, :notice => 'Changed hidden status' }
      format.json { render :json => @event, :status => :updated, :location => @event }
    end
  end

  def shuffle
    @event.hacks.each do |hack|
      hack.sort_rand = Random.rand
      hack.save!
    end

    redirect_to order_event_path(@event)
  end

  # DELETE /events/1
  # DELETE /events/1.json
  def destroy
    @event.destroy

    respond_to do |format|
      format.html { redirect_to events_url }
      format.json { head :no_content }
    end
  end

  private

  def load_event
    if @event.nil?
      @event = Event.includes(:hacks_completed => [:confirmed_members, :unconfirmed_members], :hacks_in_progress => [:confirmed_members, :unconfirmed_members]).find_by_fbid!(params[:id])
    end
    
    authorize!(params[:action].to_sym, @event)
  end
end
