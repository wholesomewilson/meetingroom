require 'test_helper'

class TimeslotTest < ActiveSupport::TestCase

  def setup
    @timeslot = timeslots(:one)
  end

  test 'validity' do
    @timeslot.valid?
  end

  test 'invalid without start_time' do
    @timeslot.start_time = nil
    refute @timeslot.valid?, "saved timeslots without start_time"
    assert_not_nil @timeslot.errors[:start_time], 'no validation error for start_time present'
  end

  test 'invalid without end_time' do
    @timeslot.end_time = nil
    refute @timeslot.valid?, "saved timeslots without end_time"
    assert_not_nil @timeslot.errors[:end_time], 'no validation error for end_time present'
  end

  test "has a method to return string" do
    @string = @timeslot.check_box_name
    assert @string == "07:00 - 07:30", "string does not match"
  end

end
