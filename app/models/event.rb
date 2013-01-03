class Event < ActiveRecord::Base
  has_many :hacks, :dependent => :destroy
  has_many :hacks_in_progress, :source => :hacks, :class_name => 'Hack', :conditions => 'hacks.published_fbid IS NULL'
  has_many :hacks_completed, :source => :hacks, :class_name => 'Hack', :conditions => 'hacks.published_fbid IS NOT NULL'
  belongs_to :event_source
  attr_accessible :fbid, :name, :time_end, :time_start
  validates_uniqueness_of :fbid

  def to_param
    fbid
  end

  def sorted_hacks
    hacks.sort do |a, b|
      a.sort_rand <=> b.sort_rand
    end
  end

  def tz_start
    timezoneize(time_start)
  end

  def tz_end
    timezoneize(time_end)
  end

  def timezoneize(t)
    TZInfo::Timezone.get(timezone).utc_to_local(t)
  end

  def attending?(user, api)
    return true if user.id.nil?
    attendees(api).include?(user.fbid)
  end

  def attendees(api)
    key = fbid + ':attendees'
    Rails.cache.fetch(key, :expires_in => 2.minutes) do
      set = {}
      api.get_connections(fbid, 'attending').each do |info|
        if info['rsvp_status'] == 'attending'
          id = info['id']
          set[id] = id
        end
      end

      set.keys
    end
  end
end
