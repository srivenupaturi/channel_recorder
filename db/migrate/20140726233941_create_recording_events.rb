class CreateRecordingEvents < ActiveRecord::Migration
  def change
    create_table :recording_events do |t|
      t.integer :user_id
      t.integer :channel_id
      t.datetime :start_time
      t.datetime :end_time
      t.integer :priority
      t.integer :recurring
      t.boolean :enabled

      t.timestamps
    end
  end
end
