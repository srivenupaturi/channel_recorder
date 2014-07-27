require 'spec_helper'

describe "channels/show" do
  before(:each) do
    @channel = assign(:channel, stub_model(Channel,
      :name => "Name",
      :frequency => 1,
      :channel_number => 3
    ))
  end

  it "renders attributes in <p>" do
    render
    rendered.should match(/Name/)
    rendered.should match(/1/)
    rendered.should match(/3/)
  end
end
