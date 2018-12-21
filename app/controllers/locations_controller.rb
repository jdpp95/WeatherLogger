  class LocationsController < ApplicationController

	def index
		@locations = Location.all
	end

  def show
  	@location = Location.find(params[:id])
    @station = Station.find(@location.station)
    @past_24_hours = Record.where(time: (Time.now - 1.day)..Time.now).where(
      station_id: @location.station.id).order(:time)
=begin
    if number_of_records > 0
      @conditions = (Record.where(station: @station).order(:time).last).temperature 
        + (@station.elevation - @location.elevation)/180
    else
      @conditions = nil
    end
=end
  end
  
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

  def update_weather_data
    @location = Location.find(params[:id])
    @station = Station.find(@location.station)
    if is_outdated(@location.id)
      past_24_hours = CurrentConditions.new.get_past_24_hours(@station.id)
      unless past_24_hours == 503
        past_24_hours.each do |h|
          #puts h
          #Check if it already exists 
          observation_time = (DateTime.parse h["LocalObservationDateTime"])
          #last_observation = Record.where(location_id: @location.id).order(:time).last
          #last_observation_time = last_observation.nil? ? Time.now + 10.year : last_observation.time
          puts "h[time]: " + observation_time.to_s
          existence = Record.where(station_id: @station.id)
            .where(time: observation_time).exists?
          #puts existence? ("exists :D" : "Does not exist!") + " *************************************"
          number_of_records = Record.count

          if (not existence) or number_of_records == 0
            #puts "New record......................................."
            record = Record.new
            record.time = observation_time
            t = h["Temperature"]["Metric"]["Value"]
            record.temperature = t
            record.humidity = h["RelativeHumidity"]
            record.conditions = h["WeatherText"]
            record.icon = h["WeatherIcon"]
            record.cloud_cover = h["CloudCover"]
            record.station = @station
            record.save
          #else
            #puts "Already exists.............................."
          end
        end
      end
    end

    redirect_to location_path(@location)
  end

  private

  def location_params
  	params.require(:location).permit(:name, :department, :country, :latitude, :longitude, :elevation, :city)
  end

  def is_outdated(st_id)
    if Record.where(station_id: st_id).take.nil?
      return true
    end

    last_record_time = (Record.where(location_id: loc_id).order(:time).last).time
    puts "Last record time: " + last_record_time.to_s
    puts "Timespan : " + (Time.now - last_record_time).to_s
    return (Time.now - last_record_time) > 1.hour
  end
end