class CurrentConditions
	include HTTParty

	attr_reader :options

	def initialize
		api_key = ENV['APIKEY']
		@options = {
			query: {
				apikey: api_key,
				#q: string_coordinates,
				language: 'es-ES',
				details: false
			}
		}
	end

	def get_data(geolocation, last_24_hours)
		#puts "Options hash" + @options.to_s
		if last_24_hours
			@options[:query][:details] = true
			HTTParty.get('http://dataservice.accuweather.com/currentconditions/v1/' + 
				geolocation.to_s + '/historical/24', @options)
		else
			HTTParty.get('http://dataservice.accuweather.com/currentconditions/v1/' + 
				geolocation.to_s, @options)
		end
	end

	def get_current_conditions(geolocation)
		data = get_data(geolocation, false)
		check_response(data)
	end

	def get_past_24_hours(geolocation)
		data = get_data(geolocation, true)
		check_response(data)
	end

	def check_response(data)
		if data.code.to_i == 200
			data.parsed_response
		elsif data.code.to_i == 400
			raise "Aprenda a hacer peticiones perro jijueputa"
		elsif data.code.to_i == 401
			raise "El API key al igual que tu es inválida"
		elsif data.code.to_i == 422
			raise "Pero que es esa mierda??"
		elsif data.code.to_i == 503
			return 503
		else
			raise "Error fetching data from AccuWeather API, error " + data.code.to_s
		end
	end
end