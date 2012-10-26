class CreateHackMembersAssocs < ActiveRecord::Migration
  def change
    create_table :hack_members_assocs do |t|
      t.integer :hack_id
      t.integer :user_id
      t.boolean :confirmed, :default => false

      t.timestamps
    end
  end
end
