class CreateHacks < ActiveRecord::Migration
  def change
    create_table :hacks do |t|
      t.string :name
      t.text :description
      t.string :url
      t.string :source_url
      t.string :image_url
      t.integer :event_id
      t.float :sort_rand, :default => 0
      t.boolean :first, :default => false
      t.string :published_fbid

      t.timestamps
    end
  end
end
