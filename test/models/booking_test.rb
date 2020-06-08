require 'test_helper'

class BookingTest < ActiveSupport::TestCase

  def setup
    @booking = bookings(:one)
    @user = users(:testuser)
  end

  test 'validity' do
    assert @booking.valid?
  end

  test 'invalid without start_date' do
    @booking.start_date = nil
    refute @booking.valid?, 'saved booking without start_date'
    assert_not_nil @booking.errors[:start_date], 'no validation error for start_date present'
  end

  test 'invalid due to is_not_taken' do
    @booking.save
    @new_booking = @user.bookings.new(user_id: 1, room_id: 1, timeslot_id: 2, start_date: DateTime.new(2020, 6, 10))
    assert !@new_booking.is_not_taken, 'saved booking after failing is_not_taken'
  end

end
