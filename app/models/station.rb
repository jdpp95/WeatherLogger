class Station < ApplicationRecord
	has_many :locations
	has_many :records
end
