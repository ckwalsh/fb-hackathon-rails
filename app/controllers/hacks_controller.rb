class HacksController < ApplicationController
  before_filter :load_hack, :except => [:new, :create]
  before_filter :load_event
  before_filter :verify_event, :except => [:new, :show, :create]

  # GET /hacks/1
  # GET /hacks/1.json
  def show
    respond_to do |format|
      format.html # show.html.erb
      format.json { render :json => @hack }
    end
  end

  def submit
    data = {}
    data[:message] = @hack.description
    data[:link] = @hack.url unless @hack.url.blank?
    data[:picture] = @hack.image_url unless @hack.image_url.blank?
    data[:name] = @hack.name
    data[:place] = @event.event_source.fbid
    fbids = []
    @hack.confirmed_members.each do |user|
      fbids.push user.fbid
    end
    data[:tags] = fbids.join(',')
    begin
      result = @api.put_connections(@event.fbid, "feed", data)
      @hack.published_fbid = result['id']
      @hack.save!
    rescue Koala::Facebook::APIError => e
      flash[:errors] = [e.message]
    end
    
    redirect_to @event
  end

  def like
    @api.put_like(@hack.published_fbid)
    @hack.clear_like_cache
    redirect_to @event
  end

  def unlike
    @api.delete_like(@hack.published_fbid)
    @hack.clear_like_cache
    redirect_to @event
  end

  # GET /hacks/1/edit
  def edit
  end
  
  # GET /hacks/
  def new
    @hack = Hack.new
    @friends = []
  end

  # POST /hacks
  # POST /hacks.json
  def create
    @friends = params[:friends] || []
    @hack = Hack.new(params[:hack])
    @hack.sort_rand = Random.rand
    @hack.event_id = @event.id

    if !@hack.save
      respond_to do |format|
        format.html { render :action => "new" }
        format.json { render :json => @hack.errors, :status => :unprocessable_entity }
      end
      return
    end

    assoc = HackMembersAssoc.new
    assoc.hack = @hack
    assoc.user = @current_user
    assoc.confirmed = true
    assoc.save!
    @friends.each do |friend_id|
      friend = User.get_or_create_by_fbid(friend_id, @api);
      assoc = HackMembersAssoc.new
      assoc.hack = @hack
      assoc.user = friend
      assoc.confirmed = true
      assoc.save!
    end

    respond_to do |format|
      format.html { redirect_to @event, :notices => ['Hack was successfully created.'] }
      format.json { render :json => @hack, :status => :created, :location => [@event, @hack] }
    end
  end

  # PUT /hacks/1
  # PUT /hacks/1.json
  def update
    respond_to do |format|
      if @hack.update_attributes(params[:hack])
        format.html { redirect_to @event, :notices => ['Hack was successfully updated.'] }
        format.json { head :no_content }
      else
        format.html { render :action => "edit" }
        format.json { render :json => @hack.errors, :status => :unprocessable_entity }
      end
    end
  end

  # DELETE /hacks/1
  # DELETE /hacks/1.json
  def destroy
    @hack.destroy

    respond_to do |format|
      format.html { redirect_to event_url(@event) }
      format.json { head :no_content }
    end
  end

  def join
    assoc = HackMembersAssoc.new
    assoc.hack = @hack
    assoc.user = @current_user
    assoc.save!
    
    redirect_to @event
  end

  def confirm_member
    assocs = HackMembersAssoc.where(:hack_id => @hack.id, :user_id => params[:user_id]).all
    assocs.each do |assoc|
      assoc.confirmed = true
      assoc.save!
    end

    redirect_to edit_event_hack_path(@event, @hack)
  end

  def remove_member
    assocs = HackMembersAssoc.where(:hack_id => @hack.id, :user_id => params[:user_id]).all
    assocs.each do |assoc|
      assoc.destroy
    end

    redirect_to edit_event_hack_path(@event, @hack)
  end

  private

  def load_hack
    if @hack.nil?
      id = params[:id] || params[:hack_id]
      @hack = Hack.find(id)
    end
    
    authorize!(params[:action].to_sym, @hack)
  end

  def load_event
    @event = Event.find_by_fbid(params[:event_id])
  end

  def verify_event
    @hack.event_id == @event.id or raise "Hack does not belong to event"
  end

end
