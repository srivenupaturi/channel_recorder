require 'spec_helper'

describe "channels/index" do
  before(:each) do
    assign(:channels, [
      stub_model(Channel,
        :name => "Name",
        :frequency => 1,
        :channel_number => 3
      ),
      stub_model(Channel,
        :name => "Name",
        :frequency => 1,
        :channel_number => 3
      )
    ])
  end

  it "renders a list of channels" do
    render
    assert_select "tr>td", :text => "Name".to_s, :count => 2
    assert_select "tr>td", :text => 1.to_s, :count => 2
    assert_select "tr>td", :text => 3, :count => 2
  end
end
