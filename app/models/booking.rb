class Booking < ApplicationRecord
  belongs_to :user
  belongs_to :room
  belongs_to :timeslot
  validates :start_date, presence: true

  def is_not_taken
    @bookings = Room.find(room_id).bookings.where(start_date: start_date)
    @bookings.each do |booking|
      if booking.timeslot.id == timeslot_id.to_i
        errors.add(:timeslot, "is taken")
        return false
      end
    end
    return true
  end
end
