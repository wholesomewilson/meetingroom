class Timeslot < ApplicationRecord
  has_many :bookings
  
  validates :start_time, :end_time, presence: true
end
