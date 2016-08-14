class Frontend::ReservationsController < FrontendController
  def index
    # Send an email to notify about booking request to the ride lister 
    # UserMailer.reservation_email(current_user).deliver_now
  end

  def create
    #revervaion-calendar

    redirect_to frontend_reservations_index_path
  end

  def create
    #revervaion-calendar
    start_time = params[:startTime]
    end_time = params[:endTime]
    address = params[:address]
    price = params[:price]
    
    
    ride = Ride.find(params[:id])
    schedule = ride.schedules.find(params[:schedule_id])  
    schedule.booked = true
    if schedule.save
      #redirect_to frontend_reservations_index_path
      head :ok, content_type: "text/html", notice: "Pay attention to the road" 
      #UserMailer.reservation_email(current_user, start_time, end_time, address, price).deliver_now!
    end
  end
end
