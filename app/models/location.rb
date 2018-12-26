class Location < ApplicationRecord
	belongs_to :station
	#has_many :records
	validates :city, presence: true
	validates :department, presence: true
	validates :latitude, presence: true, numericality: true
	validates :longitude, presence: true, numericality: true
	validates :elevation, presence: true, numericality: true
end
