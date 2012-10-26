class AddRoles < ActiveRecord::Migration
  def up
    add_column :users, :role, :string

    User.all.each do |u|
      if u.admin
        u.role = 'admin'
        u.save!
      end
    end

    remove_column :users, :admin
  end

  def down
    add_column :users, :admin, :boolean

    User.all.each do |u|
      if u.role == 'admin'
        u.admin = true
        u.save!
      end
    end
    
    remove_column :users, :role
  end
end
