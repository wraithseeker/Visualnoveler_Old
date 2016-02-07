class UsersController < ApplicationController
  include UsersHelper
  before_action :authenticate_user!, :only => [:crop] #:edit , :update

  def show
  	@user = User.find(params[:id])
    authorize @user
  	@posts = @user.posts.paginate(:page => params[:page], :per_page => 6).order('created_at DESC')
    @lib = @user.library_entries.where(favourite: true).limit(8)
    if user_signed_in?
      if current_user == @user 
        @new_post =  @user.posts.build
      else
        @user_lib = @user.library_entries
        @current_user_lib = current_user.library_entries
        @similarities = @user_lib.map{|lib| lib[:vn_id] } & @current_user_lib.map {|lib| lib[:vn_id]}
        @similar_lib = @current_user_lib.select { |f| @similarities .include? f[:vn_id] }
        #some bad looping?
      end
    end

    @comments = Comment.where(wall_author_id: @user.id).order('created_at DESC').paginate(:page => params[:page], :per_page => 10)
    @new_comment = @user.comments.build
    # @new_comment.update_attribute(:wall_user_id,@user.id)
  end

  def index
    # kinda bad for the long term, should be changed.
    #2 is the number to check if they have a min of two library_entries
    @random = User.where.not(:poster_image => nil).joins(:library_entries).group("users.id").having("count(library_entries.id) > ?",2).order("RANDOM()").limit(14)
  end

  def library
    @user = User.find(params[:id])
    @lib = @user.library_entries
    @lib_fav = @user.library_entries.where(favourite: true)
    @lib_completed = @lib.where(status: "complete")
    @lib_wishlist = @lib.where(status: "wishlist")
    @lib_dropped = @lib.where(status: "drop")
    @lib_watched = @lib.where(status: "watch")
  end

  def update_lib_notes

    @user = User.find(params[:id])
    @lib = @user.library_entries
  end

  def similar
    @user = User.find(params[:id])
    @user_lib = @user.library_entries
    @current_user_lib = current_user.library_entries
    @similarities = @user_lib.map{|lib| lib[:vn_id] } & @current_user_lib.map {|lib| lib[:vn_id]}
    @similar_lib = @current_user_lib.order('vn_id ASC').select{ |f| @similarities .include? f[:vn_id] }
    @similar_user_lib_rating = @user_lib.order('vn_id ASC').select { |f| @similarities .include? f[:vn_id] }
  end

  def watch
	  @user = User.find(params[:id])
    authorize @user
  	@lib = @user.library_entries.where(status: "watch")
  end

  def wishlist
  	@user = User.find(params[:id])
    authorize @user
  	@lib = @user.library_entries.where(status: "wishlist")
  end

  def favourite
    @user = User.find(params[:id])
    authorize @user
    @lib = @user.library_entries.where(favourite: true)
  end

  def drop
	   @user = User.find(params[:id])
    authorize @user
     @lib = @user.library_entries.where(status: "drop")
  end

  def completed
     @user = User.find(params[:id])
     authorize @user
     @lib = @user.library_entries.where(status: "complete")
  end

  def edit
     #@user = User.find(params[:id])
     authorize @user
  end

  def change_password
    @user = User.find(params[:id])
  end

  def update_avatar
    @user = current_user
    @user.update_attributes(user_params)
    flash[:success] = "it worked"
    redirect_to user_path(@user)
  end

  def update
      @user = User.find(params[:id])
      authorize @user
      if @user.update(user_params)
        flash[:success] = "You have successfully updated your profile!"
        redirect_to user_path(@user)
      else
        flash[:danger] = "There was an error updating your profile"
        render 'change_password'
      end
  end
  def crop
    @user = User.find(params[:id])
    authorize @user
  end

    private
    def user_params
       params.require(:user).permit(:poster_image_crop_x, :poster_image_crop_y, :poster_image_crop_w, :poster_image_crop_h,:name,:bio,:role,:current_password,:password,:password_confirmation)
    end

end
