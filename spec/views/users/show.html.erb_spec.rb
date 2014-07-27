require 'spec_helper'

describe "users/show" do
  before(:each) do
    @user = assign(:user, stub_model(User,
      :fname => "Fname",
      :lname => "Lname",
      :email => "Email",
      :password => "Password"
    ))
  end

  it "renders attributes in <p>" do
    render
    # Run the generator again with the --webrat flag if you want to use webrat matchers
    rendered.should match(/Fname/)
    rendered.should match(/Lname/)
    rendered.should match(/Email/)
    rendered.should match(/Password/)
  end
end
