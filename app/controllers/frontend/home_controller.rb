class Frontend::HomeController < FrontendController
  def index
    @notification = Notification.new
  end
end
