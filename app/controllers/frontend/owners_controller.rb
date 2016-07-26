class Frontend::OwnersController < FrontendController
  before_action :set_owner, only: [:show, :edit, :update, :destroy]

  # GET /owners
  # GET /owners.json
  def index
    @owners = Owner.all
  end

  # GET /owners/1
  # GET /owners/1.json
  def show
    @profile_picture = @owner.profile_picture.last["url"] if @owner.profile_picture?
  end

  # GET /owners/new
  def new
    @owner = Owner.new
  end

  # GET /owners/1/edit
  def edit
  end

  # POST /owners
  # POST /owners.json
  def create
    @owner = Owner.new(owner_params)
    pictures = Rails.cache.read("images")
    pictures.each do |picture|
      case picture[:image_type]
      
      when "profile_pic"
        @owner.profile_picture.push(picture)
      when "documents"
        @owner.id_proof_documents.push(picture)
      else
        "Why I see this??"
      end
    end

    Rails.cache.delete('images')
    

    respond_to do |format|
      if @owner.save
        format.html { redirect_to @owner, notice: 'Owner was successfully created.' }
        format.json { render :show, status: :created, location: @owner }
      else
        format.html { render :new }
        format.json { render json: @owner.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /owners/1
  # PATCH/PUT /owners/1.json
  def update
    pictures = Rails.cache.read("images").nil? ? []:Rails.cache.read("images")
    pictures.each do |picture|
      case picture[:image_type]
      
      when "profile_pic"
        @owner.profile_picture.push(picture)
      when "documents"
        @owner.id_proof_documents.push(picture)
      else
        "Why I see this??"
      end
    end

    Rails.cache.delete('images')

    respond_to do |format|
      if @owner.update(owner_params)
        format.html { redirect_to @owner, notice: 'Owner was successfully updated.' }
        format.json { render :show, status: :ok, location: @owner }
      else
        format.html { render :edit }
        format.json { render json: @owner.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /owners/1
  # DELETE /owners/1.json
  def destroy
    @owner.destroy
    respond_to do |format|
      format.html { redirect_to owners_url, notice: 'Owner was successfully destroyed.' }
      format.json { head :no_content }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_owner
      @owner = Owner.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def owner_params
      params.require(:owner).permit(:first_name, :last_name, :email, :phone_number, :profile_picture, :address_line_1, :address_line_2, :city, :state, :country, :pincode, :parmanent_address, :office_email, :id_proof_documents, :age, :height, :number_of_bike, :price_segment, :market_price, :reference, :reference_name, :reference_email, :reference_phone_number, :verified, :verification_comment, :verified_by)
    end
end
