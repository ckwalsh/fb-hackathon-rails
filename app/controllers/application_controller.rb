class ApplicationController < ActionController::Base
  protect_from_forgery

  before_filter :setup_user
  before_filter :setup_time

  private
  
  def current_user
    @current_user
  end

  def setup_user
    oauth = Koala::Facebook::OAuth.new(Rails.configuration.fb_app_id, Rails.configuration.fb_app_secret, "#{request.protocol}#{request.host_with_port}/")
    info = oauth.get_user_info_from_cookies(cookies)
    @api = Koala::Facebook::API.new(info['access_token']) unless info.nil?
    @app_api = Koala::Facebook::API.new(oauth.get_app_access_token)
    fbid = info.nil? ? false : info['user_id']
    @current_user = User.get_or_create_by_fbid(fbid, @api)
  end

  def setup_time
    @now = Time.new
  end
end
