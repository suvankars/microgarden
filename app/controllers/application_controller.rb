class ApplicationController < ActionController::Base
  layout :layout_by_resource
  # Prevent CSRF attacks by raising an exception.
  # For APIs, you may want to use :null_session instead.
  #protect_from_forgery with: :exception

  before_action :configure_permitted_parameters, if: :devise_controller?

   protected

   def configure_permitted_parameters
    devise_parameter_sanitizer.for(:sign_up) << :admin
    # devise_parameter_sanitizer.permit(:sign_up, keys: [:email, :password, :password_confirmation, :admin])
   end


  protected

  def layout_by_resource
    if devise_controller?
      "frontend/application"
    end
  end
end
