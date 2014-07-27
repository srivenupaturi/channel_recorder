class CreateChannels < ActiveRecord::Migration
  def change
    create_table :channels do |t|
      t.string :name
      t.integer :frequency
      t.string :channel_number

      t.timestamps
    end
  end
end
