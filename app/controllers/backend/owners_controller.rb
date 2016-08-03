class Backend::OwnersController < BackendController
  before_filter :authenticate_user!
  load_and_authorize_resource
  # GET /riders
  # GET /riders.json
  # Soul purpose of this controller is to render index 
  # of owners inside backend template
  # If I found better approach to render that, 
  # may delete this controller
  def index
    @owners = Owner.all
    render 'frontend/owners/index'
  end
end
