class RecordingEvent < ActiveRecord::Base
  attr_accessible :channel_id, :enabled, :end_time, :priority, :recurring, :start_time, :user_id


  validates_numericality_of :priority, :greater_than_or_equal_to => 1, :less_than_or_equal_to => 3, :message => "can only be 1, 2 or 3"
  validates_numericality_of :recurring, :greater_than_or_equal_to => 1, :less_than_or_equal_to => 3, :message => "can only be 1, 2 or 3"
  validate :validate_end_time
  validate :validate_event_conflicts

  belongs_to :user
  belongs_to :channel

  scope :active_user_recording_events, lambda{|user| { :conditions => { :user_id => user.id, :enabled => true } }}
  before_save :detect_and_fix_resolvable_conflict_events
  
  def user
    User.find(self[:user_id])
  end
 
  def validate_end_time
    if(self.end_time.to_i <= self.start_time.to_i)
      errors.add(:recording_event, "End time should be greater than Start Time")
    end
  end

  # TYPE-1 FULL OVERLAP    :e1 is a subset of e2
  # TYPE-2 PARTIAL OVERLAP :e1 starts first
  # TYPE-3 PARTIAL OVERLAP :e2 starts first 
  # TYPE-4 FULL OVERLAP    :e2 is a subset of e1
  def self.overlap_type(e1, e2)
    if(e1[:start_time] < e2[:start_time] && e1[:end_time] > e2[:end_time])
      'TYPE-4'
    elsif(e1[:start_time] > e2[:start_time] && e1[:start_time] < e2[:end_time])
      if (e1[:end_time] > e2[:start_time] && e1[:end_time] < e2[:end_time])
        'TYPE-1'
      else
        'TYPE-3'
      end
    elsif(e1[:end_time] > e2[:start_time] && e1[:end_time] < e2[:end_time])
      'TYPE-2'
    end
  end

  def self.fix_resolvable_conflict_events(e1, e2, overlap_type)

    # e1 has to be higher priority than e1 to fix a conflict
    # otherwise, validations fail and this point should never hit
    return unless e1.priority > e2.priority

    if(overlap_type == 'TYPE-1')
      # create a new event to extend e2 after e1 ends
      post_overlap_event = RecordingEvent.new('user_id' => e2[:user_id], 'channel_id' => e2[:channel_id], 'start_time' => e1[:end_time], 'end_time' => e2[:end_time], 'priority' => e2[:priority], 'recurring' => e2[:recurring], 'enabled' => e2[:enabled])
      # update e2 to end when e1 starts
      e2[:end_time] = e1[:start_time]
      e2.save!
      post_overlap_event.save!
    elsif(overlap_type == 'TYPE-2')
      e2[:start_time] = e1[:end_time]
      e2.save!
    elsif(overlap_type == 'TYPE-3')
      e2[:end_time] = e1[:start_time]
      e2.save!
    elsif(overlap_type == 'TYPE-4')
      # e1 fully ecliplses e2 which is a lower priority
      e2[:enabled]= false
      e2.save!
    end
  end

  def detect_conflicts_events_ignoring_priority
    RecordingEvent.active_user_recording_events(user).select{|e| self.class.overlap_type(self, e)}
  end

  # non-resolvable conflicts (lower priority events can NOT replace higher priority events)
  def detect_conflict_events_with_priority
    events = RecordingEvent.active_user_recording_events(user).select{|e| (e.id != self[:id]) &&  (e.priority >= self[:priority])}
    events.select{|e| self.class.overlap_type(self, e)}
  end

  # resolvable conflicts (higher priority events can replace lower priority events)
  def detect_and_fix_resolvable_conflict_events
    events = RecordingEvent.active_user_recording_events(user)
    events.each do |e|
      overlap_type = self.class.overlap_type(self, e) 
      unless overlap_type.nil?
        self.class.fix_resolvable_conflict_events(self, e, overlap_type)
      end
    end
  end

  def validate_event_conflicts
    clashed_events = detect_conflict_events_with_priority
    clashed_events.each do |e|
      errors.add(':recording_event', "Schedule conflicting with #{e.channel}.") 
    end
  end
end
