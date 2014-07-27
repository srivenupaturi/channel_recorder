require 'spec_helper'

describe RecordingEvent do

  let(:attributes) { { :channel_id => 3, 
                     :user_id => 1,
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
end
