class BookingsController < ApplicationController
  # before_action :require_login

  def new
    @booking = current_user.bookings.new
    @bookings = Booking.all
    @available_slots = Room.get_available_slots(search_room_params)
  end

  def create
    params[:booking].each do |key, value|
      @booking = current_user.bookings.new(booking_params(value))
      if !@booking.is_not_taken
        flash[:alert] = @booking.errors.full_messages
        redirect_back(fallback_location: root_path) and return
      end
      @booking.save
    end
    flash[:notice] = "Your booking is successful!"
    redirect_to my_bookings_path
  end

  def destroy
    params[:booking][:update_bookings].values.each_with_index do |param, index|
      @booking = current_user.bookings.find(param["booking_id"])
      if @booking.present?
        @booking.destroy
      else
        flash[:notice] = "Oops, something wrong happened. Please try again."
        redirect_to my_bookings_path and return
      end
    end
    flash[:notice] = "Success! Your booking is cancelled."
    redirect_to my_bookings_path
  end

  def update
    @tranferee = User.find_by_email(params[:booking][:user_email])
    if !@tranferee.present? || current_user == @tranferee
      flash[:notice] = "Email address is invalid, please try again."
      redirect_to my_bookings_path and return
    else
      params[:booking][:update_bookings].values.each_with_index do |param, index|
        @booking = current_user.bookings.find(param["booking_id"])
        @booking.update(user: @tranferee)
        if !@booking.save
          flash[:notice] = "Oops, something wrong happened. Please try again."
          redirect_to my_bookings_path and return
        end
      end
      flash[:notice] = "Success! Your booking has been transferred to #{@tranferee.email}"
      redirect_to my_bookings_path
    end
  end

  def edit
    respond_to do |format|
      format.js { render 'edit.js.erb' }
    end
  end

  private
  def booking_params(params)
    params.permit(:room_id, :timeslot_id, :start_date)
  end

  def search_room_params
    params.require(:booking).permit(:size, :start_date, :end_date, :start_time, :end_time)
  end

end
