class ChangeChannelTypeInChannelsTable < ActiveRecord::Migration
  def up
    change_column :channels, :channel_number, :integer, :unique => true
  end

  def down
    change_column :channels, :channel_number, :string, :unique => false
  end
end
