class Location < ApplicationRecord
  has_many :flights, class_name: 'Flight', foreign_key: 'from_id'
  has_many :flights, class_name: 'Flight', foreign_key: 'to_id'
end
