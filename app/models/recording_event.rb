class RecordingEvent < ActiveRecord::Base
  attr_accessible :channel_id, :enabled, :end_time, :priority, :recurring, :start_time, :user_id


  validates_numericality_of :priority, :greater_than_or_equal_to => 1, :less_than_or_equal_to => 3, :message => "can only be 1, 2 or 3"
  validates_numericality_of :recurring, :greater_than_or_equal_to => 1, :less_than_or_equal_to => 3, :message => "can only be 1, 2 or 3"
  validate :validate_end_time
  validate :validate_event_conflicts

  belongs_to :user
  belongs_to :channel

  scope :active_user_recording_events, lambda{|user| { :conditions => { :user_id => user.id, :enabled => true } }}
  after_save :conflicts_resolution
  
  def user
    User.find(self[:user_id])
  end
 
  def validate_end_time
    if(self.end_time.to_i <= self.start_time.to_i)
      errors.add(:recording_event, "End time should be greater than Start Time")
    end
  end

  def self.events_overlapping? e1, e2
    (e2[:start_time] < e1[:start_time] && e2[:end_time] > e1[:end_time]) || (e2[:start_time] > e1[:start_time] && e2[:start_time] < e1[:end_time]) || (e2[:end_time] > e1[:start_time] && e2[:end_time] < e1[:end_time])
  end

  def detect_conflicts_with_priority
    events = RecordingEvent.active_user_recording_events(user).select{|e| e.priority >= priority}
    events.select{|e| self.class.events_overlapping?(self, e)}
  end

  def detect_conflicts_ignoring_priority
    RecordingEvent.active_user_recording_events(user).select{|e| self.class.events_overlapping?(self, e)}
  end

  def conflicts_resolution
    detect_conflicts_ignoring_priority
  end

  def validate_event_conflicts
    clashed_events = detect_conflicts_with_priority
    clashed_events.each do |e|
      errors.add_to_base("Schedule conflicting with #{e.channel}.") 
    end
  end

end
