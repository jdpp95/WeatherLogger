class Location < ApplicationRecord
	belongs_to :station
	has_many :records
	validates :name, presence: true
end
