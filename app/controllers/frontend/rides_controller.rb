class Frontend::RidesController < FrontendController
  before_filter :authenticate_user!, :except => [:index, :show]
  

  load_and_authorize_resource

  before_action :set_ride, only: [:show_ride, :get_rides, :calendar, :show, :edit, :update, :destroy]
  
  RADIOUS = 15; #mile
  DEFAULT_CATEGORY_NAME = "Bicycle"
  MIN_NO_SEAT = 1
  
  

  def index
    #binding.pry
    # If search box is clicked without typing any address 
    # There will be value params[:search] = ""
    # If so, delete stored session search value
      
    session[:search] = nil if params[:search] == ""
    
    # If search box is never clicked then
    # params[:search] = nil
    # Then load params from session
    # Situation 1: User came in this page after searching a city
    # then user selecting filter criteria
    # Then ajax request comes here, obviously params[:search] is nil for
    # All ajax request came from filter 
    # So, restore parama value from session
    # Is there any better, simpler way to do it? 

    params[:search] = session[:search] if !params[:search].present?


    #save search params to session for future requests, like filter
    session[:search] = params[:search] if !params[:search].nil?

    #binding.pry
    rides = Ride.near(params[:search], RADIOUS)
    
    
    
    @filterrific = initialize_filterrific(
      rides.empty? ? Ride.all : rides,
      params[:filterrific],
       select_options: {
        with_subcategory_id: Subcategory.options_for_select,
        with_rider_height: RiderHeight.options_for_select,
        with_frame_size: FrameSize.options_for_select,
        with_morning_rental_lt: Ride.options_for_select,
        with_created_at_gte: Ride.options_for_select,
        with_created_at_lt: Ride.options_for_select
      },
    ) or return

  
    if params[:filterrific].present?
      @rides = @filterrific.find.page(params[:page])
    elsif params[:search].present?
      @rides = Ride.near(params[:search], RADIOUS)
    else
      @rides = Ride.all
    end

    #again filter by date.. bad
    if params[:drop_of].present? && params[:drop_of].present?
      @rides = filter_by_date(@rides, params[:pick_up], params[:drop_of])
    end
    
    @hash = Gmaps4rails.build_markers(@rides) do |ride, marker|
      marker.lat ride.latitude
      marker.lng ride.longitude
      marker.json({:id => ride.id })
      #marker.picture({
      #   "url": ActionController::Base.helpers.image_path('marker.png'),
      #   "width":  50,
      #   "height": 50
      # })
      marker.title   "i'm the title"
      
      marker.infowindow render_to_string(:partial => "frontend/rides/map_infowindow", :locals => { :ride => ride})
      #marker.infowindow (render_to_string :partial => "frontend/rides/map_infowindow", :locals => {ride})
      #marker.infowindow "hello!"
    end
    
    if request.xhr?
      payload = {"rides": JSON::parse(@rides.to_json), "hash": @hash }
      respond_to do |format|
        format.json { render :json => payload}
        format.js 
      end
    end

  end

  def my_ride_offers
    if current_user.admin?
      @rides = Ride.all
    else
      @rides = current_user.rides.all
    end
  end

  def my_rides

  end
  

  def get_rides
    events = []
    schedules = @ride.schedules.between(params[:start], params[:end])
    #schedules = schedules.select { |s| !s.booked  }
    schedules.each do |schedule|
      events << schedule.format(@ride)
    end

    render json: events
  end

  def availability
  end
  
  def show
     @filterrific = initialize_filterrific(
      @ride,
      params[:filterrific],
       select_options: {
        with_created_at_gte: Ride.options_for_select
      },
    ) or return

    @cover_image = @ride.images.first["url"] if @ride.images?
    @profile_picture = @ride.user.owner.profile_picture.last["url"] if @ride.user.owner.profile_picture?
    respond_to do |format|
      format.html {  }
      format.js {}
    end
    #max_available_seat = @ride.number_of_workstations
    #@workstations = (MIN_NO_SEAT..max_available_seat)
    #@default_number = @workstations.first
  end

  def show_ride
    @cover_image = @ride.images.first["url"] if @ride.images?
    respond_to do |format|
      format.html {  }
    end
  end


  def new
    _user_is_owner?
    #TBD: refactor
    #Run rake db:seed to populate categories

    @subcategories = default_category.subcategories.map{|sub| [sub.name, sub.id] }
    @default_subcategory = @subcategories.first

    @ride = Ride.new
  end


  def edit
    @subcategories = default_category.subcategories.map{|sub| [sub.name, sub.id] }
    @default_subcategory = [@ride.subcategory.name, @ride.subcategory_id]
  end

  def calendar
    _user_is_owner?
    
  end

  def create
    @ride = Ride.new(ride_params)
    @ride.images = Rails.cache.read("images")
    Rails.cache.delete('images')
    @ride.category_id = default_category.id
    @ride.user = current_user
    respond_to do |format|
      if @ride.save
        format.html { redirect_to calendar_ride_path(@ride), notice: 'Listing was successfully created.' }
        format.json { render :show, status: :created, location: @ride }
      else
        format.html { render :new }
        format.json { render json: @ride.errors, status: :unprocessable_entity }
      end
    end
  end


  def update
    old_images = @ride.images
    parked_images = Rails.cache.read("images")
    Rails.cache.delete('images')
    parked_images = parked_images.nil? ? old_images : parked_images
    @ride.update_column :images , parked_images
    
    respond_to do |format|
      if @ride.update(ride_params)
        format.html { redirect_to show_ride_ride_path(@ride), notice: 'Listing was successfully updated.' }
        format.json { render :show, status: :ok, location: @ride }
      else
        format.html { render :edit }
        format.json { render json: @ride.errors, status: :unprocessable_entity }
      end
    end
  end

  def destroy
    @ride.schedules.destroy_all
    @ride.destroy
    #ride_id will be used to remove rideing from index page
    #TBD remove marker from map. is it required?

    @ride_id = @ride.id #or params[:id]
    respond_to do |format|
      format.html { redirect_to root_path, notice: 'Listing was successfully destroyed.' }
      format.js {}
    end
  end

  def _user_is_owner?
    render 'devise/registrations/instruction' and return unless current_user.is_owner?
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_ride
      @ride = Ride.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white ride through.
    def ride_params
      params.require(:ride).permit(:title, :description, :rider_height, :frame_size, :hourly_rental, :morning_rental, :evening_rental, :daily_rental, :weekly_rental, :willing_to_deliver, :address, :city, :state, :pincode, :landmark, :subcategory_id, :model, :purchase_year, :make, :market_price, :extras=>[])
    end

    def default_category
      Category.where( name: DEFAULT_CATEGORY_NAME).first
    end

    def filter_by_date(rides, pick_up, drop_of)
      #pick_up_time = DateTime.strptime(pick_up, "%m/%d/%Y %H:%M %P")
      #drop_of_time = DateTime.strptime(drop_of, "%m/%d/%Y %H:%M %P")
      # Now only date, no time
      pick_up_time = DateTime.strptime(pick_up, "%m/%d/%Y")
      drop_of_time = DateTime.strptime(drop_of, "%m/%d/%Y")
      scheduled_ride = []
      rides.each do |ride|
          scheduled_ride.push(ride) if ride.avilable?(pick_up_time, drop_of_time)
      end
      scheduled_ride
    end
end
