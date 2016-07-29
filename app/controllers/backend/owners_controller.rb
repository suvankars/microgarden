class Backend::OwnersController < BackendController

  # GET /riders
  # GET /riders.json
  def index
    @owners = Owner.all
    render 'frontend/owners/index'
  end
end
