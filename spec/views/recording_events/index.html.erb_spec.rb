require 'spec_helper'

describe "recording_events/index" do
  before(:each) do
    assign(:recording_events, [
      stub_model(RecordingEvent,
        :user_id => 1,
        :channel_id => 2,
        :priority => 3,
        :recurring => 4,
        :enabled => false
      ),
      stub_model(RecordingEvent,
        :user_id => 1,
        :channel_id => 2,
        :priority => 3,
        :recurring => 4,
        :enabled => false
      )
    ])
  end

  it "renders a list of recording_events" do
    render
    # Run the generator again with the --webrat flag if you want to use webrat matchers
    assert_select "tr>td", :text => 1.to_s, :count => 2
    assert_select "tr>td", :text => 2.to_s, :count => 2
    assert_select "tr>td", :text => 3.to_s, :count => 2
    assert_select "tr>td", :text => 4.to_s, :count => 2
    assert_select "tr>td", :text => false.to_s, :count => 2
  end
end
