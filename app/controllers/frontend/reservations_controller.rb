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
    requested_ws_count = params[:no_of_ws].to_i
    
    ride = Ride.find(params[:id])
    remaining_ws = ride.number_of_workstations - requested_ws_count
    ride.update_column :number_of_workstations, remaining_ws if remaining_ws >= 0
    


    #redirect_to frontend_reservations_index_path
    head :ok, content_type: "text/html", notice: "Pay attention to the road" 
    #UserMailer.reservation_email(current_user, start_time, end_time, address, price).deliver_now!
  end
end
