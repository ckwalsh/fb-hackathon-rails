require "net/http"
require "net/https"

class EventSource < ActiveRecord::Base
  attr_accessible :fbid
  validates_uniqueness_of :fbid
  has_many :events

  def name
    if @source_name.nil?
      uri = URI::parse("http://graph.facebook.com/" + self.fbid)
      response = Net::HTTP.get_response(uri)
      body = response.body
      obj = JSON.parse(body)
      @source_name = obj['name'] || "Error finding name"
    end

    return @source_name
  end

  def reload_events!(api)
      return if api.nil?
      events = api.get_connections(fbid, 'events')

      events.each do |event_obj|
        fbid = event_obj['id']
        event = Event.where(:fbid => fbid).first || Event.new(:fbid => fbid)
        event.name = event_obj['name']
        event.event_source = self
        event.time_start = Time.parse(event_obj['start_time'])
        event.time_end = Time.parse(event_obj['end_time'])
        event.timezone = event_obj['timezone']
        event.save!
      end
  end
end
