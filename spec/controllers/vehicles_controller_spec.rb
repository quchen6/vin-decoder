require 'spec_helper'

# This spec was generated by rspec-rails when you ran the scaffold generator.
# It demonstrates how one might use RSpec to specify the controller code that
# was generated by Rails when you ran the scaffold generator.
#
# It assumes that the implementation code is generated by the rails scaffold
# generator.  If you are using any extension libraries to generate different
# controller code, this generated spec may or may not pass.
#
# It only uses APIs available in rails and/or rspec-rails.  There are a number
# of tools you can use to make these specs even more expressive, but we're
# sticking to rails and rspec-rails APIs to keep things simple and stable.
#
# Compared to earlier versions of this generator, there is very limited use of
# stubs and message expectations in this spec.  Stubs are only used when there
# is no simpler way to get a handle on the object needed for the example.
# Message expectations are only used when there is no simpler way to specify
# that an instance is receiving a specific message.

describe VehiclesController do

  let(:vin)     { "1N4AL3AP4DC295509" }

  # This should return the minimal set of attributes required to create a valid
  # Vehicle. As you add validations to Vehicle, be sure to
  # update the return value of this method accordingly.
  def valid_attributes
    { vin: vin }
  end

  # This should return the minimal set of values that should be in the session
  # in order to pass any filters (e.g. authentication) defined in
  # VehiclesController. Be sure to keep this updated too.
  def valid_session
    {}
  end

  before :all do
    Vehicle.delete_all
  end

  before :each do
    VCR.insert_cassette("vins/nissan_altima")
  end

  after :each do
    VCR.eject_cassette
  end

  describe "GET index" do
    it "assigns all vehicles as @vehicles" do
      vehicle = Vehicle.create! valid_attributes
      get :index, {}, valid_session
      assigns(:vehicles).should eq([vehicle])
    end
  end

  describe "GET show" do
    it "assigns the requested vehicle as @vehicle" do
      vehicle = Vehicle.create! valid_attributes
      get :show, {:id => vehicle.to_param, format: :json}, valid_session
      assigns(:vehicle).should eq(vehicle)
    end
  end

  describe "POST create" do
    describe "with valid params" do
      it "creates a new Vehicle" do
        expect {
          post :create, {:vehicle => valid_attributes, format: :json}, valid_session
        }.to change(Vehicle, :count).by(1)
      end

      it "assigns a newly created vehicle as @vehicle" do
        post :create, {:vehicle => valid_attributes, format: :json}, valid_session
        assigns(:vehicle).should be_a(Vehicle)
        assigns(:vehicle).should be_persisted
      end

      it "redirects to the created vehicle" do
        post :create, {:vehicle => valid_attributes, format: :json}, valid_session
        response.response_code.should eq 200
      end
    end

    describe "with invalid params" do
      it "assigns a newly created but unsaved vehicle as @vehicle" do
        # Trigger the behavior that occurs when invalid params are submitted
        Vehicle.any_instance.stub(:save).and_return(false)
        post :create, {:vehicle => { vin: vin }, format: :json}, valid_session
        assigns(:vehicle).should be_a_new(Vehicle)
      end

      it "returns a 422" do
        # Trigger the behavior that occurs when invalid params are submitted
        Vehicle.any_instance.stub(:save).and_return(false)
        post :create, {:vehicle => { vin: vin }, format: :json}, valid_session
        response.response_code.should be 422
      end
    end
  end

  describe "DELETE destroy" do
    it "destroys the requested vehicle" do
      vehicle = Vehicle.create! valid_attributes
      expect {
        delete :destroy, {:id => vehicle.to_param}, valid_session
      }.to change(Vehicle, :count).by(-1)
    end

    it "redirects to the vehicles list" do
      vehicle = Vehicle.create! valid_attributes
      delete :destroy, {:id => vehicle.to_param}, valid_session
      response.should redirect_to(vehicles_url)
    end
  end

end
