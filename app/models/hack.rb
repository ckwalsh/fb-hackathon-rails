class Hack < ActiveRecord::Base
  belongs_to :event
  has_many :hack_members_assocs
  has_many :confirmed_members_assocs, :source => :hack_members_assocs, :conditions => {:confirmed => true}
  has_many :unconfirmed_members_assocs, :source => :hack_members_assocs, :conditions => {:confirmed => false}
  has_many :confirmed_members, :through => :hack_members_assocs, :source => :user, :class_name => 'User'
  has_many :unconfirmed_members, :through => :hack_members_assocs, :source => :user, :class_name => 'User'

  attr_accessible :description, :image_url, :name, :source_url, :url, :first
  validates :name, :description, :event, :presence => true
  validates_format_of :url, :image_url, :source_url, :with => URI::regexp(%w(http https)), :allow_blank => true

  def sort_rand
    self[:sort_rand] + (self.first ? 1 : 0)
  end

  def submitted?
    !published_fbid.blank?
  end

  def likes?(user, api)
    likes(api).include?(user.fbid)
  end

  def likes(api)
    return [] if api.nil? || !submitted?
    Rails.cache.fetch(likes_key, :expires_in => 2.minutes) do
      likes = []
      post = api.get_object(published_fbid)
      unless post.nil?
        raw_likes = post.has_key?('likes') ? post['likes']['data'] : []
        raw_likes.each do |row|
          likes.push row['id']
        end
      end

      likes
    end
  end

  def like_count(api)
    return likes(api).length
  end

  def likes_key
    published_fbid.nil? ? nil : (published_fbid + ':likes')
  end

  def clear_like_cache
    Rails.cache.delete(likes_key)
  end
end
