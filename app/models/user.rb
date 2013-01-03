class User < ActiveRecord::Base
  has_many :hack_members_assoc, :dependent => :destroy
  has_many :hacks, :through => :hack_members_assoc

  attr_accessible :fbid, :name

  def self.get_or_create_by_fbid(fbid, fb_api)
    return User.new if fbid.nil? || !fbid
    user = User.where(:fbid => fbid).first
    if user.nil?
      return User.new if fb_api.nil?

      user_info = fb_api.get_object(fbid)
      user = User.create!(:fbid => fbid, :name => user_info['name'])
    end

    return user
  end
end
