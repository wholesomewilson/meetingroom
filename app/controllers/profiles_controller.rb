class ProfilesController < ApplicationController
  def show
    start_date = DateTime.now.beginning_of_day - 30.days
    end_date = DateTime.now.beginning_of_day
    @past_bookings = current_user.bookings.where(:start_date => start_date..end_date)
    @current_bookings = current_user.bookings.where("start_date > ?", DateTime.now )
  end
end
