class Common::ImagesController < BackendController
  before_action :set_resource, only: [:park_images, :show, :edit, :destroy]

  def create
    add_more_images(images_params[:images])
    flash[:error] = "Failed uploading images" unless @product.save
    redirect_to :back
  end

  def destroy
    remove_by_pub_id(params[:img_pub_id], params[:resource] )
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
    if !@resource.nil? 
      images = @resource.images # copy the old images 
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
      data_values.each do |index, image_metadata|
        metadata = image_metadata.permit(:public_id, :version, :signature, :width, :height, :format, :resource_type, :created_at, :bytes, :type, :etag, :url, :secure_url, :original_filename, :delete_token, :path, :thumbnail_url)
        images << metadata.to_h
      end
    end
    images
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
    #Deter mine wheather this delete request for which type of resource
    #Product or List 
    binding.pry
    @resource_type = params[:resource_type].constantize
    @resource = @resource_type.find(params[:id])
  end


  def add_more_images(new_images)
    images = @product.images # copy the old images 
    images += new_images # concat old images with new ones
    @product.images = images # assign back
  end

  def remove_by_pub_id(img_public_id, resource_type)
    remain_images = @resource.images # copy the array
    deleted_image = @resource.images.delete_if { |image| image["public_id"] == img_public_id } # delete the target image
    Cloudinary::Uploader.destroy(img_public_id, options = {})
    @resource.images = remain_images # re-assign back
  end

  
  def images_params
    params.require(:product).permit({images: []}) # allow nested params as array
  end
  

end
