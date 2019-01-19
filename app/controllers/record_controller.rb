class RecordController < ApplicationController
	def remove_duplicates
		@location = params[:location]
		records = Record.all.order(:station_id, :time)
		previous = nil
		records.each do |r|
			puts r.time.to_s + ", " + r.station_id.to_s
			if(previous == r)
				previous = r
				r.delete
			end
			previous = r
		end
		redirect_to root_path
	end
end
