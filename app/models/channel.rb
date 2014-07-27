class Channel < ActiveRecord::Base
  attr_accessible :channel_number, :frequency, :name
end
