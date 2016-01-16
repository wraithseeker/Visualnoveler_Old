class LibraryEntriesController < ApplicationController

  	before_action :authenticate_user!, :only => [:edit,:update]
	def edit
		@lib = LibraryEntry.find(params[:id])
		authorize @lib
	end
	def update
		@lib = LibraryEntry.find(params[:id])
		if @lib.update(lib_params)

  		# 	respond_to do |format| 
  		# 		format.js
 			# end                   
			flash[:success] = "Library Entry is updated successfully!"
			redirect_to library_user_path(@lib.user)  
		else
			flash[:danger] = "Failed to update the Library Entry"
			redirect_to session[:previous_url] 
		end
	end

	private

	def lib_params
			params.require(:library_entry).permit(:status,:vn_id,:user_id,:name,:favourite,:notes,:id)
		end
end
