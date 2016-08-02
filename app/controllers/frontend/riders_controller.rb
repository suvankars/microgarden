class Frontend::RidersController < FrontendController
  load_and_authorize_resource
  before_action :set_rider, only: [:show, :edit, :update, :destroy]

  # GET /riders
  # GET /riders.json
  def index
    #if current_user.admin?
      @riders = Rider.all
    # else
    #   @riders = current_user.rider
    # end
  end

  def my_rider_profile
    #One User should have one rider profile only 
    
    if !current_user.rider.nil?
      @rider = current_user.rider
      @profile_picture = @rider.profile_picture.last["url"] if @rider.profile_picture?
      render :show
    else
      render 'devise/registrations/instruction'
    end
  end

  

  # GET /riders/1
  # GET /riders/1.json
  def show
    @profile_picture = @rider.profile_picture.last["url"] if @rider.profile_picture?
  end

  def copy_owner
    owner_attrs = current_user.owner.attributes.reject{|r| r["id"]}
    @rider = Rider.new(owner_attrs.select{ |key, _| Rider.attribute_names.include? key })
    @rider.address_line2 = current_user.owner.address_line_2 #that was a typo in migrate and I am too lazzy to make it correct
    
    #To show copied image in view
    @rider.profile_picture = current_user.owner.profile_picture
    @rider.id_proof_documents = current_user.owner.id_proof_documents

    #To send those images to "create" action
    Rails.cache.write("profile_images", current_user.owner.profile_picture) 
    Rails.cache.write("document_images", current_user.owner.id_proof_documents) 

    @rider
  end

  # GET /riders/new
  def new
    if current_user.is_owner?
      @rider = copy_owner
    else  
      @rider = Rider.new
    end

    @rider.user = current_user
  end

  # GET /riders/1/edit
  def edit
  end

  def copy_images(rider)
    profile_picture = Rails.cache.read("profile_images")
    if profile_picture
      rider.profile_picture.push(*profile_picture)
      Rails.cache.delete('profile_images')
    end
      
    document_images = Rails.cache.read("document_images")
    if document_images
      rider.id_proof_documents.push(*document_images)
      Rails.cache.delete('document_images')
    end
    rider    
  end
  # POST /riders
  # POST /riders.json
  def create
    @rider = Rider.new(rider_params)
    @rider.user = current_user
    pictures = Rails.cache.read("images")
    if pictures
      pictures.each do |picture|
        case picture[:image_type]
        
        when "profile_pic"
          @rider.profile_picture.push(picture)
        when "documents"
          @rider.id_proof_documents.push(picture)
        else
          "Why I see this??"
        end
      end
    end

    #This is a quck fix for copy profile
    @rider = copy_images(@rider)

    Rails.cache.delete('images')

    respond_to do |format|
      if @rider.save
        format.html { redirect_to rider_path(@rider), notice: 'Rider was successfully created.' }
        format.json { render :show, status: :created, location: @rider }
      else
        format.html { render :new }
        format.json { render json: @rider.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /riders/1
  # PATCH/PUT /riders/1.json
  def update
    pictures = Rails.cache.read("images").nil? ? []:Rails.cache.read("images")
    pictures.each do |picture|
      case picture[:image_type]
      
      when "profile_pic"
        @rider.profile_picture.push(picture)
      when "documents"
        @rider.id_proof_documents.push(picture)
      else
        "Why I see this??"
      end
    end

    Rails.cache.delete('images')
    respond_to do |format|
      if @rider.update(rider_params)
        format.html { redirect_to rider_path(@rider), notice: 'Rider was successfully updated.' }
        format.json { render :show, status: :ok, location: @rider }
      else
        format.html { render :edit }
        format.json { render json: @rider.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /riders/1
  # DELETE /riders/1.json
  def destroy
    @rider.destroy
    respond_to do |format|
      format.html { redirect_to riders_url, notice: 'Rider was successfully destroyed.' }
      format.json { head :no_content }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_rider
      @rider = Rider.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def rider_params
      params.require(:rider).permit(:user_id, :first_name, :last_name, :email, :phone_number, :profile_picture, :address_line_1, :address_line2, :city, :state, :country, :pincode, :parmanent_address, :office_email, :id_proof_documents, :age, :height, :number_of_bike, :price_segment, :market_price, :reference, :reference_name, :reference_email, :reference_phone_number, :verified, :verification_comment, :verified_by)
    end
end
