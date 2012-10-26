module ApplicationHelper
  def avatar_tag(user, type = 'square')
    image_tag("//graph.facebook.com/#{user.fbid}/picture?type=#{type}", :title => user.name, :alt => user.name)
  end

  def fb_user_path(user)
    fbid_path(user.fbid)
  end

  def fbid_path(fbid)
    '//www.facebook.com/' + fbid
  end
end
