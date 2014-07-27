require 'spec_helper'

describe ChannelsController do

  let(:valid_attributes) { { "name" => "MyString", 'channel_number' => 3, 'frequency' => 322 } }

  let(:valid_session) { {} }

  describe "GET index" do
    it "assigns all channels as @channels" do
      channel = Channel.create! valid_attributes
      get :index, {}, valid_session
      assigns(:channels).should eq([channel])
    end
  end

  describe "GET show" do
    it "assigns the requested channel as @channel" do
      channel = Channel.create! valid_attributes
      get :show, {:id => channel.to_param}, valid_session
      assigns(:channel).should eq(channel)
    end
  end

  describe "GET new" do
    it "assigns a new channel as @channel" do
      get :new, {}, valid_session
      assigns(:channel).should be_a_new(Channel)
    end
  end

  describe "GET edit" do
    it "assigns the requested channel as @channel" do
      channel = Channel.create! valid_attributes
      get :edit, {:id => channel.to_param}, valid_session
      assigns(:channel).should eq(channel)
    end
  end

  describe "POST create" do
    describe "with valid params" do
      it "creates a new Channel" do
        expect {
          post :create, {:channel => valid_attributes}, valid_session
        }.to change(Channel, :count).by(1)
      end

      it "assigns a newly created channel as @channel" do
        post :create, {:channel => valid_attributes}, valid_session
        assigns(:channel).should be_a(Channel)
        assigns(:channel).should be_persisted
      end

      it "redirects to the created channel" do
        post :create, {:channel => valid_attributes}, valid_session
        response.should redirect_to(Channel.last)
      end
    end

    describe "with invalid params" do
      it "assigns a newly created but unsaved channel as @channel" do
        # Trigger the behavior that occurs when invalid params are submitted
        Channel.any_instance.stub(:save).and_return(false)
        post :create, {:channel => { "name" => "invalid value" }}, valid_session
        assigns(:channel).should be_a_new(Channel)
      end

      it "re-renders the 'new' template" do
        # Trigger the behavior that occurs when invalid params are submitted
        Channel.any_instance.stub(:save).and_return(false)
        post :create, {:channel => { "name" => "invalid value" }}, valid_session
        response.should render_template("new")
      end
    end
  end

  describe "PUT update" do
    describe "with valid params" do
      it "updates the requested channel" do
        channel = Channel.create! valid_attributes
        # Assuming there are no other channels in the database, this
        # specifies that the Channel created on the previous line
        # receives the :update_attributes message with whatever params are
        # submitted in the request.
        Channel.any_instance.should_receive(:update_attributes).with({ "name" => "MyString" })
        put :update, {:id => channel.to_param, :channel => { "name" => "MyString" }}, valid_session
      end

      it "assigns the requested channel as @channel" do
        channel = Channel.create! valid_attributes
        put :update, {:id => channel.to_param, :channel => valid_attributes}, valid_session
        assigns(:channel).should eq(channel)
      end

      it "redirects to the channel" do
        channel = Channel.create! valid_attributes
        put :update, {:id => channel.to_param, :channel => valid_attributes}, valid_session
        response.should redirect_to(channel)
      end
    end

    describe "with invalid params" do
      it "assigns the channel as @channel" do
        channel = Channel.create! valid_attributes
        # Trigger the behavior that occurs when invalid params are submitted
        Channel.any_instance.stub(:save).and_return(false)
        put :update, {:id => channel.to_param, :channel => { "name" => "invalid value" }}, valid_session
        assigns(:channel).should eq(channel)
      end

      it "re-renders the 'edit' template" do
        channel = Channel.create! valid_attributes
        # Trigger the behavior that occurs when invalid params are submitted
        Channel.any_instance.stub(:save).and_return(false)
        put :update, {:id => channel.to_param, :channel => { "name" => "invalid value" }}, valid_session
        response.should render_template("edit")
      end
    end
  end

  describe "DELETE destroy" do
    it "destroys the requested channel" do
      channel = Channel.create! valid_attributes
      expect {
        delete :destroy, {:id => channel.to_param}, valid_session
      }.to change(Channel, :count).by(-1)
    end

    it "redirects to the channels list" do
      channel = Channel.create! valid_attributes
      delete :destroy, {:id => channel.to_param}, valid_session
      response.should redirect_to(channels_url)
    end
  end

end
