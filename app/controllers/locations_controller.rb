class LocationsController < ApplicationController

	def index
		@locations = Location.all
	end

  def show
  	@location = Location.find(params[:id])
    @station = Station.find(@location.station)
  end
#https://www.google.com/maps/dir/4.611824,-74.2067825/'5.9841853,-72.7525802'/@5.1943473,-73.2430541,9z/data=!4m8!4m7!1m1!4e1!1m3!2m2!1d-72.7525802!2d5.9841853!3e0
  def new
    @location = Location.new
  end

  def edit
    @location = Location.find(params[:id])
  end

  def create
  	@location = Location.new(location_params)
    string_coordinates = @location.latitude.to_s + ", " + @location.longitude.to_s

    geolocation = Geolocation.new.get_geolocation(string_coordinates)
    puts "Geolocation key: " + geolocation.to_s + " ...................................."
    unless Station.exists?(geolocation["Key"])
      station = Station.new
      station.id = geolocation["Key"]
      station.place = geolocation["LocalizedName"]
      station.latitude = geolocation["GeoPosition"]["Latitude"]
      station.longitude = geolocation["GeoPosition"]["Longitude"]
      station.elevation = geolocation["GeoPosition"]["Elevation"]["Metric"]["Value"]
      station.save
    end
    @location.station = Station.find(geolocation["Key"])
    #render json: geolocation, status: :ok
    #@location.station.create

  	if @location.save
  	 redirect_to @location
    else
      render 'new'
    end

  #rescue StandardError => e
  #  render json: { errors: e.message }, status: :unprocessable_entity
  end

  def update
    @location = Location.find(params[:id])

    if @location.update(location_params)
      redirect_to @location
    else
      render 'edit'
    end
  end

  def destroy
    @location = Location.find(params[:id])
    @location.destroy

    redirect_to locations_path
  end

  private
  def location_params
  	params.require(:location).permit(:name, :department, :country, :latitude, :longitude, :altitude)
  end
end