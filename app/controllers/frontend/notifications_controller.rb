class Frontend::NotificationsController < FrontendController

  def edit
  end

  def update
  end

  def show
  end

  def destroy
   
  end

  def create
    @notification = Notification.new(notification_params)

    respond_to do |format|
      if @notification.save
        format.html { redirect_to @notification, notice: 'Size was successfully created.' }
        format.json { render :show, status: :created, location: @notification }
        format.js {}
      else
        format.html { render :new }
        format.json { render json: @notification.errors, status: :unprocessable_entity }
      end
    end
  end

private
  # Use callbacks to share common setup or constraints between actions.
 

  def notification_params
    params.require(:notification).permit(:message, :email, :phone, :pincode, :name)
  end
end
