class StationsController < ApplicationController
	def show
		@station = Station.find(params[:id])
	end

	def edit
		@station = Station.find(params[:id])
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
end
