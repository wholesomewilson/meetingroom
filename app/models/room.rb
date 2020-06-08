class Room < ApplicationRecord
  has_many :bookings
  has_many :users, through: :bookings

  validates :unit, :name, :size, :hint, presence: true
end
