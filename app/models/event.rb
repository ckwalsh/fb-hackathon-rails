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
    attendees(api).include?(user.id)
  end

  def attendees(api)
    key = fbid + ':attendees'
    fbids = Rails.cache.fetch(key, :expires_in => 2.minutes) do
      set = {}
      api.get_connections(fbid, 'attending').each do |info|
        if info['rsvp_status'] == 'attending'
          id = info['id']
          set[id] = id
        end
      end

      set.keys
    end

    User.where(:fbid => fbids).all.collect do |u|
      u.id
    end
  end

  def load_old_hacks!(api)
    return if api.nil?

    api.get_connections(fbid, 'feed').each do |post|
      next unless post.has_key?('application') && post['application']['id'] == '136348336398305'

      
      u = post.has_key?('picture') && URI.parse(post['picture'])
      q = u && CGI::parse(u.query)
      
      hack = Hack.find_by_published_fbid(post['id']) || Hack.new
      hack.published_fbid = post['id']
      puts post.inspect
      hack.name = post['name'] || 'Unable to load name'
      hack.description = post['description'] || 'Unable to load description'
      hack.url = post.has_key?('link') ? post['link'] : nil
      hack.image_url = q.instance_of?(Hash) ? q['src'].first : nil
      hack.event_id = self.id
      hack.save!

      user = User.get_or_create_by_fbid(post['from']['id'], api)
      
      assoc = HackMembersAssoc.new
      assoc.hack_id = hack.id
      assoc.user_id = user.id
      assoc.confirmed = true
      assoc.save!
    end
  end
end
