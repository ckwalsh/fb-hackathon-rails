class CreateEventSources < ActiveRecord::Migration
  def change
    create_table :event_sources do |t|
      t.string :fbid

      t.timestamps
    end
  end
end
