class Timeslot < ApplicationRecord

  has_many :bookings
  validates :start_time, :end_time, presence: true

  def check_box_name
    "#{start_time} - #{end_time}"
  end
  
end
