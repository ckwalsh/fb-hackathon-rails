class ApplicationController < ActionController::Base
  protect_from_forgery

  before_filter :setup_user
  before_filter :setup_time

  private
  
  def current_user
    @current_user
  end

  def setup_user
    oauth = Koala::Facebook::OAuth.new(
      Rails.configuration.fb_app_id,
      Rails.configuration.fb_app_secret,
      "#{request.protocol}#{request.host_with_port}/"
    )
    
    user = session[:user_id] && User.find_by_id(session[:user_id])
    
    if user
      access_token = user.access_token
      if user.access_token && user.token_expire > Time.now.to_i
        api = Koala::Facebook::API.new(user.access_token)
        begin
          profile = api.get_object('me')
          puts profile.inspect
          if profile['id'] == user.fbid
            @current_user = user
            @api = api
          end
        rescue Koala::Facebook::APIError => err
          user.access_token = nil
          user.token_expire = nil
          user.save!
          user = nil
          reset_session
        end
      end
    end

    if @api.nil?
      begin
        info = oauth.get_user_info_from_cookies(cookies)
        unless info.nil?
          @api = Koala::Facebook::API.new(info['access_token'])
          fbid = info.nil? ? false : info['user_id']
        
          @current_user = User.get_or_create_by_fbid(fbid, @api)
          @current_user.access_token = info['access_token']
          @current_user.token_expire = Time.now.to_i + info['expires'].to_i
          puts @current_user.inspect
          @current_user.save!
          session[:user_id] = @current_user.id
        end
      rescue Koala::Facebook::APIError => err
        # Lets clear the cookies so we don't hit this again
        cookies.delete("fbsr_#{Rails.configuration.fb_app_id}")
      end
    end

    @current_user ||= User.new
  end

  def setup_time
    @now = Time.new
  end
end
