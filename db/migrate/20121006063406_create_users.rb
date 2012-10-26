class CreateUsers < ActiveRecord::Migration
  def change
    create_table :users do |t|
      t.string :fbid
      t.string :name
      t.boolean :admin, :default => false
    end
  end
end
