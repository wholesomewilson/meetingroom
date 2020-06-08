class Room < ApplicationRecord
  has_many :bookings
  has_many :users, through: :bookings

  validates :unit, :name, :size, :hint, presence: true

# GENERATE a list of rooms with available slots within search params
  # filtered all rooms by size and with empty slots
  # get rooms with their taken slots and filtered by start and end date
  # get available slots for all rooms
  def self.get_available_slots(params)
    @size = params["size"].to_i
    @start_time = params["start_time"]
    @end_time = params["end_time"]
    @start_date = params["start_date"]
    @end_date = params["end_date"]
    @rooms = self.get_rooms_by_size(@size)
    @rooms_with_taken_slots = get_rooms_with_taken_slots(@rooms, @start_date, @end_date)
    get_slots_available_by_time(@rooms_with_taken_slots, @start_time, @end_time)
  end

# RETURN a list of rooms based on size
  def self.get_rooms_by_size(selected_size)
    @shortlist_rooms = self.except("created_at", "updated_at").select { |room| room.size >= selected_size }
  end

# RETURN a list of available rooms with booked timeslots
  # generate an array of dates between start and end search date
  # fill up result hash with search_dates and empty arrays
  # fill up result hash with existing booked timeslots
  def self.get_rooms_with_taken_slots(rooms, start_date, end_date)
    @start_date_search = DateTime.strptime(start_date, "%d-%m-%Y")
    @end_date_search = DateTime.strptime(end_date, "%d-%m-%Y")
    @search_dates = (@start_date_search..@end_date_search).to_a.map { |d| d.strftime("%d-%m-%Y") }
    @rooms_with_taken_slots = {}
    @search_dates.each do |date|
      rooms.each do |room|
        @rooms_with_taken_slots[room] = @rooms_with_taken_slots.fetch(room, {}).merge(date => [])
      end
    end
    rooms.each do |room|
      @bookings = room.bookings.where("start_date >= ?", @start_date_search).where("start_date <= ?", @end_date_search)
      @bookings.each do |booking|
        @booking_start_date = booking.start_date.strftime("%d-%m-%Y")
        @rooms_with_taken_slots[room][@booking_start_date] = @rooms_with_taken_slots[room].fetch(@booking_start_date).push(booking.timeslot)
      end
    end
    return @rooms_with_taken_slots
  end

# RETURN a list of available rooms with available slots
  # generate a master list of timeslot in range of start and end time
  # remove existing slots from master list
  # return remaining slots
  def self.get_slots_available_by_time(rooms, start_time, end_time)
    @master_slots = generate_all_timeslots(start_time, end_time)
    rooms.each do |room, date_slots|
      date_slots.each do |date, slots|
        @temp = @master_slots - slots
        if @temp.count > 0
          date_slots[date] = @temp
        else
          date_slots[date].delete_if { |key, value| value.blank? }
        end
      end
      rooms[room].delete_if { |key, value| value.blank? }
    end
    rooms.delete_if { |key, value| value.blank? }
  end

  def self.generate_all_timeslots(start_time, end_time)
    Timeslot.select { |t| [t] if t.start_time.to_time >= start_time.to_time && t.end_time.to_time <= end_time.to_time }
  end

end
