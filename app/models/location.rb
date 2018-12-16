class Location < ApplicationRecord
	belongs_to :station
	validates :name, presence: true
end
