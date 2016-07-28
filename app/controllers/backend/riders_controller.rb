class Backend::RidersController < BackendController
  before_action :set_rider, only: [:show, :edit, :update, :destroy]

  # GET /riders
  # GET /riders.json
  def index
    @riders = Rider.all
  end

  # # GET /riders/1
  # # GET /riders/1.json
  # def show
  #   @profile_picture = @rider.profile_picture.last["url"] if @rider.profile_picture?
  # end

  # # GET /riders/new
  # def new
  #   @rider = Rider.new
  # end

  # # GET /riders/1/edit
  # def edit
  # end

  # # POST /riders
  # # POST /riders.json
  # def create
  #   @rider = Rider.new(rider_params)
  #   pictures = Rails.cache.read("images")
  #   pictures.each do |picture|
  #     case picture[:image_type]
      
  #     when "profile_pic"
  #       @rider.profile_picture.push(picture)
  #     when "documents"
  #       @rider.id_proof_documents.push(picture)
  #     else
  #       "Why I see this??"
  #     end
  #   end

  #   Rails.cache.delete('images')

  #   respond_to do |format|
  #     if @rider.save
  #       format.html { redirect_to rider_path(@rider), notice: 'Rider was successfully created.' }
  #       format.json { render :show, status: :created, location: @rider }
  #     else
  #       format.html { render :new }
  #       format.json { render json: @rider.errors, status: :unprocessable_entity }
  #     end
  #   end
  # end

  # # PATCH/PUT /riders/1
  # # PATCH/PUT /riders/1.json
  # def update
  #   pictures = Rails.cache.read("images").nil? ? []:Rails.cache.read("images")
  #   pictures.each do |picture|
  #     case picture[:image_type]
      
  #     when "profile_pic"
  #       @rider.profile_picture.push(picture)
  #     when "documents"
  #       @rider.id_proof_documents.push(picture)
  #     else
  #       "Why I see this??"
  #     end
  #   end

  #   Rails.cache.delete('images')
  #   respond_to do |format|
  #     if @rider.update(rider_params)
  #       format.html { redirect_to rider_path(@rider), notice: 'Rider was successfully updated.' }
  #       format.json { render :show, status: :ok, location: @rider }
  #     else
  #       format.html { render :edit }
  #       format.json { render json: @rider.errors, status: :unprocessable_entity }
  #     end
  #   end
  # end

  # # DELETE /riders/1
  # # DELETE /riders/1.json
  # def destroy
  #   @rider.destroy
  #   respond_to do |format|
  #     format.html { redirect_to riders_url, notice: 'Rider was successfully destroyed.' }
  #     format.json { head :no_content }
  #   end
  # end

  # private
  #   # Use callbacks to share common setup or constraints between actions.
  #   def set_rider
  #     @rider = Rider.find(params[:id])
  #   end

  #   # Never trust parameters from the scary internet, only allow the white list through.
  #   def rider_params
  #     params.require(:rider).permit(:first_name, :last_name, :email, :phone_number, :profile_picture, :address_line_1, :address_line2, :city, :state, :country, :pincode, :parmanent_address, :office_email, :id_proof_documents, :age, :height, :number_of_bike, :price_segment, :market_price, :reference, :reference_name, :reference_email, :reference_phone_number, :verified, :verification_comment, :verified_by)
  #   end
end
