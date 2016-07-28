class UsersController < BackendController
  before_filter :authenticate_user!
  #before_filter :admin_user,   :only => [:index,:destroy]

  def index
    @users = User.all 
    authorize! :read, User, :message => "Unable to show you all users! you must be Admin"
  end

  def destroy
    authorize! :destroy, User, :message => "Unable to destroy this user! you must be Admin"
    user = User.find(params[:id])
    authorize! :manage, user
    user.destroy 
    respond_to do |format|
      format.html { redirect_to users_path, notice: 'User was successfully destroyed.' }
      format.js {}
    end
  end

  private
  def admin_user
    if  !current_user.admin?
     #redirect_to users_path, notice: 'User was successfully destroyed.' 
   end
  end 
end
