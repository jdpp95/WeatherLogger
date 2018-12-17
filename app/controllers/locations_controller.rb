class LocationsController < ApplicationController

	def index
		@locations = Location.all
	end

  def show
  	@location = Location.find(params[:id])
    @station = Station.find(@location.station)
    #@past_24_hours = CurrentConditions.new.get_past_24_hours(@station.id)
    
    if is_outdated(@location.id)
      past_24_hours = CurrentConditions.new.get_past_24_hours(@station.id)
      if past_24_hours == 503
        raise 'Cannot update info'
      else
        past_24_hours.each do |h|
          puts h
          #Check if it already exists
          observation_time = h["LocalObservationDateTime"]
          if Record.find_by(time: observation_time).nil?
            record = Record.new
            record.time = observation_time
            t = h["Temperature"]["Metric"]["Value"]
            record.temperature = t + (@station.elevation - @location.elevation)/180
            record.humidity = h["RelativeHumidity"]
            record.conditions = h["WeatherText"]
            record.icon = h["WeatherIcon"]
            record.cloud_cover = h["CloudCover"]
            record.location = @location
            record.save
          end
        end
      end
    end

    @past_24_hours = Record.where(time: (Time.now - 1.day)..Time.now).where(
      location_id: @location.id).order(:time)

    @conditions = (Record.order(:time).last).temperature

=begin
    current_conditions = CurrentConditions.new.get_current_conditions(@station.id)
    if current_conditions == 503
      @conditions = "-"
    else
      station_t = current_conditions[0]["Temperature"]["Metric"]["Value"]
      @conditions = station_t + (@station.elevation - @location.elevation)/180
    end
=end
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

    if geolocation == 503
      redirect_to service_unavailable_path
    else
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

  def unavailable
  end

  private

  def location_params
  	params.require(:location).permit(:name, :department, :country, :latitude, :longitude, :elevation)
  end

  def is_outdated(loc_id)
    if Record.where(location_id: loc_id).take.nil?
      return true
    end

    last_record_time = (Record.where(location_id: loc_id).order(:time).last).time
    return (Time.now - last_record_time) > 1.hour
  end

end