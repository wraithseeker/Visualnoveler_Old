class UsersController < ApplicationController
  def show
	@user = User.find(params[:id])
	@posts = @user.posts.order('created_at DESC')
  end

  def watch
	@user = User.find(params[:id])
  	@lib = @user.library_entries.where(status: "watch")
  end

  def wishlist
	@user = User.find(params[:id])
  	@lib = @user.library_entries.where(status: "wishlist")
  end

  def drop
	@user = User.find(params[:id])
  	@lib = @user.library_entries.where(status: "drop")
  end

  def edit

  end

  def update

  end

  def index

  end
  
end
