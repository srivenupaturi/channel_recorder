require "spec_helper"

describe RecordingEventsController do
  describe "routing" do

    it "routes to #index" do
      get("/recording_events").should route_to("recording_events#index")
    end

    it "routes to #new" do
      get("/recording_events/new").should route_to("recording_events#new")
    end

    it "routes to #show" do
      get("/recording_events/1").should route_to("recording_events#show", :id => "1")
    end

    it "routes to #edit" do
      get("/recording_events/1/edit").should route_to("recording_events#edit", :id => "1")
    end

    it "routes to #create" do
      post("/recording_events").should route_to("recording_events#create")
    end

    it "routes to #update" do
      put("/recording_events/1").should route_to("recording_events#update", :id => "1")
    end

    it "routes to #destroy" do
      delete("/recording_events/1").should route_to("recording_events#destroy", :id => "1")
    end

  end
end
