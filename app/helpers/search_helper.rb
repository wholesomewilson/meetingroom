module SearchHelper
  def get_start_timeslots
    @timeslots = []
    @time = Time.new(2000, 1, 1, 7, 0, 0)
    24.times do
      @timeslots << @time.strftime("%H:%M")
      @time += 30.minutes
    end
    return @timeslots
  end

  def get_end_timeslots
    @timeslots = []
    @time = Time.new(2000, 1, 1, 7, 30, 0)
    24.times do
      @timeslots << @time.strftime("%H:%M")
      @time += 30.minutes
    end
    return @timeslots
  end
end
