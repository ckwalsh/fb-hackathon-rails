class CreateEvents < ActiveRecord::Migration
  def change
    create_table :events do |t|
      t.string :fbid
      t.integer :event_source_id
      t.string :name
      t.datetime :time_start
      t.datetime :time_end
      t.string :timezone
      t.boolean :hidden, :default => false

      t.timestamps
    end
  end
end
