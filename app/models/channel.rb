class Channel < ActiveRecord::Base
  attr_accessible :channel_number, :frequency, :name
  has_many :recording_events
end
