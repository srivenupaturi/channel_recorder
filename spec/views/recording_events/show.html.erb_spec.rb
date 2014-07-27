require 'spec_helper'

describe "recording_events/show" do
  before(:each) do
    @recording_event = assign(:recording_event, stub_model(RecordingEvent,
      :user_id => 1,
      :channel_id => 2,
      :priority => 3,
      :recurring => 4,
      :enabled => false
    ))
  end

  it "renders attributes in <p>" do
    render
    # Run the generator again with the --webrat flag if you want to use webrat matchers
    rendered.should match(/1/)
    rendered.should match(/2/)
    rendered.should match(/3/)
    rendered.should match(/4/)
    rendered.should match(/false/)
  end
end
