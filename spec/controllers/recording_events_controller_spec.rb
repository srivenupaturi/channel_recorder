require 'spec_helper'

describe RecordingEventsController do

  let(:valid_attributes) { { "user_id" => "1", 'channel_id' => 2, 'start_time' => Time.now, 'end_time' => (Time.now + 1.hour), 'priority' => 2, 'recurring' => 2 } }

  let(:valid_session) { {} }

  describe "GET index" do
    it "assigns all recording_events as @recording_events" do
      recording_event = RecordingEvent.create! valid_attributes
      get :index, {}, valid_session
      assigns(:recording_events).should eq([recording_event])
    end
  end

  describe "GET show" do
    it "assigns the requested recording_event as @recording_event" do
      recording_event = RecordingEvent.create! valid_attributes
      get :show, {:id => recording_event.to_param}, valid_session
      assigns(:recording_event).should eq(recording_event)
    end
  end

  describe "GET new" do
    it "assigns a new recording_event as @recording_event" do
      get :new, {}, valid_session
      assigns(:recording_event).should be_a_new(RecordingEvent)
    end
  end

  describe "GET edit" do
    it "assigns the requested recording_event as @recording_event" do
      recording_event = RecordingEvent.create! valid_attributes
      get :edit, {:id => recording_event.to_param}, valid_session
      assigns(:recording_event).should eq(recording_event)
    end
  end

  describe "POST create" do
    describe "with valid params" do
      it "creates a new RecordingEvent" do
        expect {
          post :create, {:recording_event => valid_attributes}, valid_session
        }.to change(RecordingEvent, :count).by(1)
      end

      it "assigns a newly created recording_event as @recording_event" do
        post :create, {:recording_event => valid_attributes}, valid_session
        assigns(:recording_event).should be_a(RecordingEvent)
        assigns(:recording_event).should be_persisted
      end

      it "redirects to the created recording_event" do
        post :create, {:recording_event => valid_attributes}, valid_session
        response.should redirect_to(RecordingEvent.last)
      end
    end

    describe "with invalid params" do
      it "assigns a newly created but unsaved recording_event as @recording_event" do
        # Trigger the behavior that occurs when invalid params are submitted
        RecordingEvent.any_instance.stub(:save).and_return(false)
        post :create, {:recording_event => { "user_id" => "invalid value" }}, valid_session
        assigns(:recording_event).should be_a_new(RecordingEvent)
      end

      it "re-renders the 'new' template" do
        # Trigger the behavior that occurs when invalid params are submitted
        RecordingEvent.any_instance.stub(:save).and_return(false)
        post :create, {:recording_event => { "user_id" => "invalid value" }}, valid_session
        response.should render_template("new")
      end
    end
  end

  describe "PUT update" do
    describe "with valid params" do
      it "updates the requested recording_event" do
        recording_event = RecordingEvent.create! valid_attributes
        # Assuming there are no other recording_events in the database, this
        # specifies that the RecordingEvent created on the previous line
        # receives the :update_attributes message with whatever params are
        # submitted in the request.
        RecordingEvent.any_instance.should_receive(:update_attributes).with({ "user_id" => "1" })
        put :update, {:id => recording_event.to_param, :recording_event => { "user_id" => "1" }}, valid_session
      end

      it "assigns the requested recording_event as @recording_event" do
        recording_event = RecordingEvent.create! valid_attributes
        put :update, {:id => recording_event.to_param, :recording_event => valid_attributes}, valid_session
        assigns(:recording_event).should eq(recording_event)
      end

      it "redirects to the recording_event" do
        recording_event = RecordingEvent.create! valid_attributes
        put :update, {:id => recording_event.to_param, :recording_event => valid_attributes}, valid_session
        response.should redirect_to(recording_event)
      end
    end

    describe "with invalid params" do
      it "assigns the recording_event as @recording_event" do
        recording_event = RecordingEvent.create! valid_attributes
        # Trigger the behavior that occurs when invalid params are submitted
        RecordingEvent.any_instance.stub(:save).and_return(false)
        put :update, {:id => recording_event.to_param, :recording_event => { "user_id" => "invalid value" }}, valid_session
        assigns(:recording_event).should eq(recording_event)
      end

      it "re-renders the 'edit' template" do
        recording_event = RecordingEvent.create! valid_attributes
        # Trigger the behavior that occurs when invalid params are submitted
        RecordingEvent.any_instance.stub(:save).and_return(false)
        put :update, {:id => recording_event.to_param, :recording_event => { "user_id" => "invalid value" }}, valid_session
        response.should render_template("edit")
      end
    end
  end

  describe "DELETE destroy" do
    it "destroys the requested recording_event" do
      recording_event = RecordingEvent.create! valid_attributes
      expect {
        delete :destroy, {:id => recording_event.to_param}, valid_session
      }.to change(RecordingEvent, :count).by(-1)
    end

    it "redirects to the recording_events list" do
      recording_event = RecordingEvent.create! valid_attributes
      delete :destroy, {:id => recording_event.to_param}, valid_session
      response.should redirect_to(recording_events_url)
    end
  end

end
