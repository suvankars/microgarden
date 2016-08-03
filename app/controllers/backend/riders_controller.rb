class Backend::RidersController < BackendController
  before_filter :authenticate_user!
  load_and_authorize_resource

  # Soul purpose of this controller is to render index 
  # of owners inside backend template
  # If I found better approach to render that, 
  # may delete this controlle
  # GET /riders
  # GET /riders.json
  def index
    @riders = Rider.all
    render 'frontend/riders/index'
  end

end
