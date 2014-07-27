require 'spec_helper'

describe "channels/edit" do
  before(:each) do
    @channel = assign(:channel, stub_model(Channel,
      :name => "MyString",
      :frequency => 1,
      :channel_number => "MyString"
    ))
  end

  it "renders the edit channel form" do
    render

    # Run the generator again with the --webrat flag if you want to use webrat matchers
    assert_select "form[action=?][method=?]", channel_path(@channel), "post" do
      assert_select "input#channel_name[name=?]", "channel[name]"
      assert_select "input#channel_frequency[name=?]", "channel[frequency]"
      assert_select "input#channel_channel_number[name=?]", "channel[channel_number]"
    end
  end
end
