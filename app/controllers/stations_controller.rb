class StationsController < ApplicationController
	def show
		@station = Station.find(params[:id])
	end

	def edit
		@station = Station.find(params[:id])
	end

	def update_temperature
		@station = Station.find(params[:id])
		string_coordinates = @station.latitude.to_s + ", " + @station.longitude.to_s
    geolocation = Geolocation.new.get_geolocation(string_coordinates)
		elevation = geolocation["GeoPosition"]["Elevation"]["Metric"]["Value"]

		station_avg_temperature = 0 #TODO: Compute this average
		records = Record.where(station: @station).all
		t_per_hour = Hash.new
		records.each do |r|
			hour = parse_time(r.time)
			if t_per_hour[hour].nil?
				t_per_hour[hour] = []
			end

			t_per_hour[hour] << r.temperature
		end

		t_per_hour.each do |key, hour|
			hour_avg = 0
			#puts key.to_s + ", " + hour.to_s
			hour.each { |temp| hour_avg += temp }
			hour_avg = hour_avg / hour.length
			station_avg_temperature += hour_avg
			#puts key.to_s + ", " + hour_avg.to_s
		end

		station_avg_temperature /= t_per_hour.length
		puts "Station average temperature = " + station_avg_temperature.to_s + " °C"

		@station.elevation = elevation + (Float(params[:temperature]) - station_avg_temperature)*180
		@station.save
		redirect_to station_path(@station)
	end

	def update
		@station = Station.find(params[:id])

		if @station.update(station_params)
	    redirect_to @station
	  else
	    render 'edit'
	  end
	end

	private

	def station_params
		params.require(:station).permit(:elevation)
	end

	def parse_time(time)
		return (time.seconds_since_midnight/3600).round
	end
end
