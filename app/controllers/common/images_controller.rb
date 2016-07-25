class Common::ImagesController < BackendController
  before_action :set_resource, only: [:park_images, :show, :edit, :destroy]

  def create
    add_more_images(images_params[:images])
    flash[:error] = "Failed uploading images" unless @product.save
    redirect_to :back
  end

  def destroy
    remove_by_pub_id(params[:img_pub_id], params[:resource], params[:image_type] )
    # Use this public id ro remove images from UI
    @public_id = params[:img_pub_id] 
    flash[:error] = "Failed deleting image" unless @resource.save
    
    respond_to do |format|
      format.html { redirect_to back }
      format.js { }
    end
  end

  def remove_all
    #TODO find a way to delete each elements from cloudinary_image fields
    #This is bad
    #Delete all image from cloude and as well as from DB
    if request.xhr?
      respond_to do |format|
        @product.cloudinary_images.each do |image|
          Cloudinary::Uploader.destroy(image["public_id"])
        end

        @product.cloudinary_images = [] #Just assiging blank; to get work done as of now
        @product.save
        format.js   {}
      end
    end
  end


  def previous_images
      # Incase of park_images action; no product object is initialized; till then return an empty []   

    image_type = "other" if params[:image_type].nil?  
    if !@resource.nil?
      case image_type
      when "profile_pic"
        images = @resource.profile_picture
      when "documents"
        images = @resource.id_proof_documents
      when "other" 
        images = @resource.images 
      end
    else
      images = !Rails.cache.read("images").nil? ? Rails.cache.read("images") : []
    end
    images.nil? ? [] : images
  end

  def populate_images
    #TBD
    images = previous_images
    
    if params[:data_value].present?
      data_values = params[:data_value]

      # A bad patch 
      # For Rider profie
      # There are two kind of image need to handel in a single 
      # post request one is for Profile picture
      # Another are for documents 
      # Here I add a bad patch based on image type, will add a flag 
      # For profile pic "image_type" flag will be set to "profile_pic"
      # Ex. "image_type"=>"profile_pic"
      # for documents imge_type will be "documents"
      # TBD refactor the if block

      if params[:image_type].present?
        image_info = {}
        data_values.each do |index, image_metadata|
          metadata = image_metadata.permit(:public_id, :version, :signature, :width, :height, :format, :resource_type, :created_at, :bytes, :type, :etag, :url, :secure_url, :original_filename, :delete_token, :path, :thumbnail_url)
          metadata_hash = metadata.to_h
          metadata_hash[:image_type] = params[:image_type]
          images << metadata_hash
        end
      else 
        data_values.each do |index, image_metadata|
          metadata = image_metadata.permit(:public_id, :version, :signature, :width, :height, :format, :resource_type, :created_at, :bytes, :type, :etag, :url, :secure_url, :original_filename, :delete_token, :path, :thumbnail_url)
          images << metadata.to_h
        end
      end  
    end
    images
  end
  
  def removed_parked_image
    # In case user want to delete image DURING filling up
    # FORM, removing those images from stagged area (Cache)
    binding.pry
    images = !Rails.cache.read("images").nil? ? Rails.cache.read("images") : []
    remaning_image = images.reject{|c| c["public_id"] == params[:image_id]}
    Rails.cache.write("images", remaning_image)
    render nothing: true
  end

  def park_images
    #Rails casche provides a way to pass temporary objects between controller actions. 
    
    if request.xhr?
      Rails.cache.write("images", populate_images)
      render nothing: true
    else
      #Do something!
      #DO not Assumed that everything will fine forever
    end
  end

  private

  def set_resource
    #Determine wheather this delete request for which type of resource
    #Product or List  or Ride or Rider or Lister
    #There are few issue in this dynamic calls finder.. will work on letter
    #bad patch
    if (!params[:resource_type].nil? && !params[:id].nil?) 
      @resource_type = params[:resource_type].constantize
      @resource = @resource_type.find(params[:id])
      return @resource
    end

  end


  def add_more_images(new_images)
    images = @product.images # copy the old images 
    images += new_images # concat old images with new ones
    @product.images = images # assign back
  end

  def remove_by_pub_id(img_public_id, resource_type, image_type)
    # A quick fix 
    image_type = "other" if image_type.nil? 
    case image_type
      when "profile_pic"
        remain_images = @resource.profile_picture # copy the array
        deleted_image = @resource.profile_picture.delete_if { |image| image["public_id"] == img_public_id } 
        @resource.profile_picture = remain_images
      when "documents"
        remain_images = @resource.id_proof_documents # copy the array
        deleted_image = @resource.id_proof_documents.delete_if { |image| image["public_id"] == img_public_id } 
        @resource.id_proof_documents = remain_images
      when "other"
        remain_images = @resource.images # copy the array
        deleted_image = @resource.images.delete_if { |image| image["public_id"] == img_public_id } # delete the target image
        @resource.images = remain_images
      end

    #Remove from cloude storage  
    Cloudinary::Uploader.destroy(img_public_id, options = {})
    @resource
  end

  
  def images_params
    params.require(:product).permit({images: []}) # allow nested params as array
  end
  

end
