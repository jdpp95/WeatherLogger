class Location < ApplicationRecord
	belongs_to :station
	has_many :records
	validates :city, presence: true
end
