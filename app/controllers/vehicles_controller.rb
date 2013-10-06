class VehiclesController < ApplicationController
  before_action :set_vehicle, only: [:show, :edit, :update, :destroy]
  skip_before_filter :verify_authenticity_token

  respond_to :json

  # GET /vehicles
  # GET /vehicles.json
  def index
    @vehicles = Vehicle.order("id desc").paginate(:page => params[:page], :per_page => 10)

    respond_to do |format|
      format.html
      format.json{ render json: {vehicles: @vehicles.as_json(methods: [:full_name]), 
        total_pages: @vehicles.total_pages, total_entries: @vehicles.total_entries, 
        offset: @vehicles.offset, per_page: @vehicles.per_page} }
    end
  end

  # GET /vehicles/1
  # GET /vehicles/1.json
  def show
    respond_to do |format|
      format.html
      format.json { render json: @vehicle.to_json( methods: [:full_name] ) }
    end
  end

  # GET /vehicles/new
  def new
    @vehicle = Vehicle.new
  end

  # GET /vehicles/1/edit
  def edit
  end

  # POST /vehicles
  # POST /vehicles.json
  def create
    @vehicle = Vehicle.new_from_vin(vehicle_params[:vin], params[:zip])

    respond_to do |format|
      if @vehicle.save
        format.html { redirect_to @vehicle, notice: 'Vehicle was successfully created.' }
        format.json { render json: @vehicle.to_json( methods: [:full_name] ) }
      else
        format.html { render action: 'new' }
        format.json { render json: @vehicle.to_json( methods: [:full_error_messages] ), status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /vehicles/1
  # PATCH/PUT /vehicles/1.json
  def update
    respond_to do |format|
      if @vehicle.update(vehicle_params)
        format.html { redirect_to @vehicle, notice: 'Vehicle was successfully updated.' }
        format.json { head :no_content }
      else
        format.html { render action: 'edit' }
        format.json { render json: @vehicle.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /vehicles/1
  # DELETE /vehicles/1.json
  def destroy
    @vehicle.destroy
    respond_to do |format|
      format.html { redirect_to vehicles_url }
      format.json { head :no_content }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_vehicle
      @vehicle = Vehicle.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def vehicle_params
      params.require(:vehicle).permit(:vin, :zip)
    end

end
