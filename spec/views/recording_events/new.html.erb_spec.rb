require 'spec_helper'

describe "recording_events/new" do
  before(:each) do
    assign(:recording_event, stub_model(RecordingEvent,
      :user_id => 1,
      :channel_id => 1,
      :priority => 1,
      :recurring => 1,
      :enabled => false
    ).as_new_record)
  end

  it "renders new recording_event form" do
    render

    # Run the generator again with the --webrat flag if you want to use webrat matchers
    assert_select "form[action=?][method=?]", recording_events_path, "post" do
      assert_select "input#recording_event_user_id[name=?]", "recording_event[user_id]"
      assert_select "input#recording_event_channel_id[name=?]", "recording_event[channel_id]"
      assert_select "input#recording_event_priority[name=?]", "recording_event[priority]"
      assert_select "input#recording_event_recurring[name=?]", "recording_event[recurring]"
      assert_select "input#recording_event_enabled[name=?]", "recording_event[enabled]"
    end
  end
end
