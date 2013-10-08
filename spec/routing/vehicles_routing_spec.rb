require "spec_helper"

describe VehiclesController do
  describe "routing" do

    it "routes to #index" do
      get("/vehicles").should route_to("vehicles#index")
    end

    it "routes to #show" do
      get("/vehicles/1").should route_to("vehicles#show", :id => "1")
    end

    it "routes to #create" do
      post("/vehicles").should route_to("vehicles#create")
    end

    it "routes to #destroy" do
      delete("/vehicles/1").should route_to("vehicles#destroy", :id => "1")
    end

  end
end
