class Frontend::SchedulesController < FrontendController
  # Actually monkey-patch String 
  String.include CoreExtensions::String
   
  before_action :set_schedule, only: [:move, :resize, :show, :edit, :update, :destroy]
  before_action :set_ride, only: [:move, :resize, :create, :new, :show, :edit, :destroy]
  before_action :set_ride_slot , only: [:update]


  def index
    @schedules = Schedule.all
  end


  def show
     @schedule = Schedule.last
  end


  def new
    respond_to do |format|
       format.js {render "new", locals: {mah_ride: @ride} }
    end
  end


  def edit
    respond_to do |format|
       format.js {render "edit", locals: {ride: @ride, schedule: @schedule} }
    end
  end

  

  def create
    #TODO Clean it
    @schedule = @ride.schedules.new(schedule_params)
    morning_ride  = params[:schedule][:morning_ride]
    all_day = params[:schedule][:all_day]
    weekly_ride = params[:schedule][:weekly_ride]

    # if (  morning_ride and evening_ride )
    #   if ( create_slot(:morning, @ride.schedule.new(schedule_params)) and create_slot(:evening, @ride.schedule.new(schedule_params)) )
    #     render nothing: true
    #   else
    #   end
    
    @schedule.set_morning_slot if morning_ride.to_bool 
    @schedule.set_daily_slot if all_day.to_bool
    @schedule.set_weekly_slot if weekly_ride.to_bool

    
    if @schedule.save
      render nothing: true
    else
      render text: @schedule.errors.full_messages.to_sentence, status: 422
    end
    
  end

  def create_slot(slot_time, schedule )
    case slot_time

    when :morning  
      schedule.set_morning_slot 
    when :evening
      schedule.set_evening_slot
    end

    schedule.save
  end



  def update
    respond_to do |format|
      if @schedule.update(schedule_params.except(:start_time, :end_time))
        
        if @morning_ride
          create_slot(:morning, @schedule )
        elsif @evening_ride
          create_slot(:evening, @schedule )
        end

        #@schedule.set_morning_slot if params[:schedule][:morning_ride] 
        #@schedule.set_evening_slot if params[:schedule][:evening_ride]
        #@schedule.save
        #format.html { redirect_to @schedule, notice: 'Schedule was successfully updated.' }
        #format.json { render :show, status: :ok, location: @schedule }
        format.js { render nothing: true}
      else
        #format.html { render :edit }
        #format.json { render json: @schedule.errors, status: :unprocessable_entity }
        format.js {render text: @schedule.errors.full_messages.to_sentence, status: 422}
      end
    end
  end


  def destroy
    @schedule.destroy
    respond_to do |format|
      #format.html { redirect_to ride_path(@ride), notice: 'Schedule was successfully destroyed.' }
      #format.json { head :no_content }
      format.js { render nothing: true}
    end
  end




  def move
    if @schedule
      @schedule.start_time =  delta_to_time(@schedule.start_time)
      @schedule.end_time   =  delta_to_time(@schedule.end_time)
      @schedule.save
    end
    render nothing: true
  end

  def resize
    if @schedule
      @schedule.end_time = delta_to_time( @schedule.end_time )
      @schedule.save
    end    
    render nothing: true
  end


  private
    # Use callbacks to share common setup or constraints between actions.
    def set_schedule
      @schedule = Schedule.find(params[:id])
    end

    def set_ride_slot
      @morning_ride  = params[:schedule][:morning_ride] || ""
      @evening_ride = params[:schedule][:evening_ride] || ""
    end

    def set_ride
      @ride = Ride.find(params[:ride_id])
    end

    # Never trust parameters from the scary internet, only allow the white ride through.
    def schedule_params
      params.require(:schedule).permit(:start_time, :end_time, :morning_ride, :evening_ride, :all_day)
    end

    def delta_to_time(event_time)
      (params[:delta].to_i/1000).seconds.from_now(event_time)
    end
end
