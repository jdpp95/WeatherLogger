class Geolocation
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

	def get_data(string_coordinates)
		@options[:query][:q] = string_coordinates
		#puts "Options hash" + @options.to_s
		HTTParty.get('http://dataservice.accuweather.com/locations/v1/cities/geoposition/search', @options)
	end

	def get_geolocation(string_coordinates)
		data = get_data(string_coordinates)
		if data.code.to_i == 200
			data.parsed_response
		elsif data.code.to_i == 400
			raise "Aprenda a hacer peticiones perro jijueputa"
		elsif data.code.to_i == 401
			raise "El API key al igual que tu es inválida"
		elsif data.code.to_i == 422
			raise "Pero que es esa mierda??"
		elsif data.code.to_i == 429
			raise "Too many requests, try again tomorrow."
		else
			raise "Error fetching data from AccuWeather API, error " + data.code.to_s
		end
	end
end