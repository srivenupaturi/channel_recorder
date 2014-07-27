class RecordingEvent < ActiveRecord::Base
  attr_accessible :channel_id, :enabled, :end_time, :priority, :recurring, :start_time, :user_id
  validates_numericality_of :priority, :greater_than_or_equal_to => 1, :less_than_or_equal_to => 3, :message => "can only be 1, 2 or 3"
  validates_numericality_of :recurring, :greater_than_or_equal_to => 1, :less_than_or_equal_to => 3, :message => "can only be 1, 2 or 3"
  validate :validate_end_time
 
  def validate_end_time
    if(self.end_time.to_i <= self.start_time.to_i)
      errors.add("End Time", "should be greater than Start Time")
    end
  end
end
