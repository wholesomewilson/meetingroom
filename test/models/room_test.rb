require 'test_helper'

# t.string "unit", null: false
# t.string "name"
# t.integer "size"
# t.text "hint"

class RoomTest < ActiveSupport::TestCase

  def setup
    @room = rooms(:one)
    @timeslots_set_1 = [Timeslot.find(1)]
    @timeslots_set_2 = [Timeslot.find(1), Timeslot.find(2), Timeslot.find(3)]
    @timeslots_set_3 = [Timeslot.find(4), Timeslot.find(5)]
    @date_set_1 = Set["10-06-2020", "11-06-2020"]
    @taken_rooms_set_1 = {
      Room.first => {
        "10-06-2020" => [Timeslot.find(2)],
        "11-06-2020" => []
      },
      Room.second => {
        "10-06-2020" => [Timeslot.find(2)],
        "11-06-2020" => []
      }
    }
    @available_rooms_set_1 = {
      Room.first => {
        "10-06-2020" => [Timeslot.find(1)],
        "11-06-2020" => [Timeslot.find(1), Timeslot.find(2)]
      },
      Room.second => {
        "10-06-2020" => [Timeslot.find(1)],
        "11-06-2020" => [Timeslot.find(1), Timeslot.find(2)]
      }
    }
  end

  test 'validity' do
    @room.valid?
  end

  test 'invalid without unit' do
    @room.unit = nil
    refute @room.valid?, "saved without unit"
    assert_not_nil @room.errors[:unit], 'no validation error for unit present'
  end

  test 'invalid without name' do
    @room.name = nil
    refute @room.valid?, "saved without name"
    assert_not_nil @room.errors[:name], 'no validation error for name present'
  end

  test 'invalid without size' do
    @room.size = nil
    refute @room.valid?, "saved without size"
    assert_not_nil @room.errors[:size], 'no validation error for size present'
  end

  test 'invalid without hint' do
    @room.hint = nil
    refute @room.valid?, "saved without hint"
    assert_not_nil @room.errors[:hint], 'no validation error for hint present'
  end

  test 'has method to filter room by size' do
    @shortlist_rooms = Room.get_rooms_by_size(5)
    @shortlist_rooms.each do |room|
      assert room.size >= 5, "get_rooms_by_size returns rooms with wrong size"
    end

    @shortlist_rooms = Room.get_rooms_by_size(8)
    @shortlist_rooms.each do |room|
      assert room.size >= 8, "get_rooms_by_size returns rooms with wrong size"
    end

    @shortlist_rooms = Room.get_rooms_by_size(10)
    @shortlist_rooms.each do |room|
      assert room.size >= 10, "get_rooms_by_size returns rooms with wrong size"
    end

    @shortlist_rooms = Room.get_rooms_by_size(11)
    @shortlist_rooms.each do |room|
      assert room.size >= 11, "get_rooms_by_size returns rooms with wrong size"
    end
  end

  test 'has a method to return taken slots within start and end date' do
    @rooms = Room.get_rooms_by_size(5)
    @start_date = "10-06-2020"
    @end_date = "11-06-2020"
    @rooms_with_taken_slots = Room.get_rooms_with_taken_slots(@rooms, @start_date, @end_date)
    @booking_count = Booking.where("start_date >= ?", DateTime.strptime(@start_date, "%d-%m-%Y")).where("start_date <= ?", DateTime.strptime(@end_date, "%d-%m-%Y")).count
    @count = 0
    @rooms_with_taken_slots.each do |room, dateslots|
      dateslots.each do |date, slots|
        assert DateTime.strptime(date, "%d-%m-%Y") >= DateTime.strptime(@start_date, "%d-%m-%Y"), "get_rooms_with_taken_slots return rooms before start date"
        assert DateTime.strptime(date, "%d-%m-%Y") <= DateTime.strptime(@end_date, "%d-%m-%Y"), "get_rooms_with_taken_slots return rooms after end date"
        @count += slots.count
      end
    end
    assert @count == @booking_count, "count of slots does not match"
  end

  test 'has a method to select timeslots with start and end time' do
    @timeslots = Room.generate_all_timeslots("07:00", "07:30")
    assert @timeslots == @timeslots_set_1

    @timeslots = Room.generate_all_timeslots("07:00", "08:30")
    assert @timeslots == @timeslots_set_2

    @timeslots = Room.generate_all_timeslots("08:30", "09:30")
    assert @timeslots == @timeslots_set_3
  end

  test 'has a method to return available rooms with their available timeslots' do
    @available_slots = Room.get_slots_available_by_time(@taken_rooms_set_1, "07:00", "08:00")
    assert @available_slots == @available_rooms_set_1
  end


end
