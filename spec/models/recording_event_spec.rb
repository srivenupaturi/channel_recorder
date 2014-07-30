require 'spec_helper'

describe RecordingEvent do

  let(:user) { create_user }
  let(:attributes) { { :channel_id => 3, 
                     :user_id => user.id,
                     :enabled => true,
                     :start_time => Time.now + 1.hour,
                     :end_time => Time.now + 2.hour,
                     :priority => 2,
                     :recurring => 1 }
                   }

  describe '#validations' do
    it "should fail for priority less than 1" do
      attributes[:priority] = 0
      expect(RecordingEvent.new(attributes)).to have(1).error_on(:priority)
    end

    it "should fail for priority less than 1" do
      attributes[:priority] = 4
      expect(RecordingEvent.new(attributes)).to have(1).error_on(:priority)
    end

    it "should pass for priority set in range" do
      attributes[:priority] = 2
      expect(RecordingEvent.new(attributes)).to have(0).error_on(:priority)
    end

    it "should fail for end_time less than start_time" do
      attributes[:end_time] = Time.now - 5.hour
      r = RecordingEvent.new(attributes)
      r.valid?.should == false
    end

    it "should fail for end_time less than start_time" do
      r = RecordingEvent.new(attributes)
      r.valid?.should == true
    end

    it "should fail for recurring less than 1" do
      attributes[:recurring] = 0
      expect(RecordingEvent.new(attributes)).to have(1).error_on(:recurring)
    end

    it "should fail for recurring less than 1" do
      attributes[:recurring] = 4
      expect(RecordingEvent.new(attributes)).to have(1).error_on(:recurring)
    end

    it "should pass for recurring set in range" do
      attributes[:recurring] = 2
      expect(RecordingEvent.new(attributes)).to have(0).error_on(:recurring)
    end
  end

  describe "#detect_conflict_events_with_priority" do
    before do
      @existing_event = RecordingEvent.create!( :channel_id => 3,
                     :user_id => user.id,
                     :enabled => true,
                     :start_time => Time.now + 1.hour,
                     :end_time => Time.now + 5.hour,
                     :priority => 2,
                     :recurring => 1 
                    )
      @new_event = RecordingEvent.new( :channel_id => 4,
                     :user_id => user.id,
                     :enabled => true,
                     :priority => 2,
                     :recurring => 1
                    )
    end

    it "should detect a conflict when a new event partially overlaps with an exisitng event" do
      @new_event.start_time = Time.now
      @new_event.end_time = Time.now + 2.hour
      clashed_events = @new_event.detect_conflict_events_with_priority
      clashed_events.first.id.should == @existing_event.id
    end

    it "should detect a conflict when a new event fully overlaps with an existing event" do
      @new_event.start_time = Time.now + 2.hour
      @new_event.end_time = Time.now + 3.hour
      clashed_events = @new_event.detect_conflict_events_with_priority
      clashed_events.first.id.should == @existing_event.id
    end

    it "should detect a conflict when an existing event fully overlaps with a new event" do
      @new_event.start_time = Time.now
      @new_event.end_time = Time.now + 6.hour
      clashed_events = @new_event.detect_conflict_events_with_priority
      clashed_events.first.id.should == @existing_event.id
    end

    it "should not detect a conflict when a new event with higher priority overlaps with an exisitng event" do
      @new_event.priority = 3
      @new_event.start_time = Time.now
      @new_event.end_time = Time.now + 2.hour
      clashed_events = @new_event.detect_conflict_events_with_priority
      clashed_events.size.should == 0
    end
  end

  describe "#fix_resolvable_conflict_events" do
    before do
      @existing_event = RecordingEvent.create!( :channel_id => 3,
                     :user_id => user.id,
                     :enabled => true,
                     :start_time => Time.now + 1.hour,
                     :end_time => Time.now + 5.hour,
                     :priority => 2,
                     :recurring => 1 
                    )
      @new_event = RecordingEvent.new( :channel_id => 4,
                     :user_id => user.id,
                     :enabled => true,
                     :priority => 3, # higher than existing event's priority
                     :recurring => 1
                    )
    end

    it "should be able to resolve TYPE-1 conflict" do
      @new_event.start_time = Time.now + 2.hour
      @new_event.end_time = Time.now + 3.hour
      RecordingEvent.fix_resolvable_conflict_events(@new_event, @existing_event, 'TYPE-1')
      events = user.recording_events
      events.size.should == 2
      events.first.end_time.should be_same_time_as @new_event.start_time
      events.last.start_time.should be_same_time_as @new_event.end_time
    end

    it "should be able to resolve TYPE-2 conflict" do
      @new_event.start_time = Time.now 
      @new_event.end_time = Time.now + 3.hour
      RecordingEvent.fix_resolvable_conflict_events(@new_event, @existing_event, 'TYPE-2')
      @existing_event.reload.start_time.should be_same_time_as @new_event.end_time
    end

    it "should be able to resolve TYPE-1 conflict" do
      @new_event.start_time = Time.now  + 4.hour
      @new_event.end_time = Time.now + 7.hour
      RecordingEvent.fix_resolvable_conflict_events(@new_event, @existing_event, 'TYPE-3')
      @existing_event.reload.end_time.should be_same_time_as @new_event.start_time
    end

    it "should be able to resolve TYPE-4 conflict" do
      @new_event.start_time = Time.now
      @new_event.end_time = Time.now + 7.hour
      RecordingEvent.fix_resolvable_conflict_events(@new_event, @existing_event, 'TYPE-4')
      @existing_event.reload.enabled.should be_false
    end
 end

end
