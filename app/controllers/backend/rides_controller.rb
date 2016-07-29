class Backend::RidesController < BackendController
  def index
    @rides = Ride.all
  end
end
