class Backend::OwnersController < BackendController
  before_action :set_rider, only: [:show, :edit, :update, :destroy]

  # GET /riders
  # GET /riders.json
  def index
    @owners = Owner.all
    render 'frontend/owners/index'
  end
end
