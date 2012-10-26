class HackMembersAssoc < ActiveRecord::Base
  belongs_to :hack
  belongs_to :user
  attr_accessible :confirmed, :hack_id, :user_id
end
