class Backend::RidersController < BackendController
  before_action :set_rider, only: [:show, :edit, :update, :destroy]

  # GET /riders
  # GET /riders.json
  def index
    @riders = Rider.all
    render 'frontend/riders/index'
  end

end
