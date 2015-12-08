class GenresController < ApplicationController
	before_action :authenticate_user!, :only => [:edit,:new,:update]

	def show
		@genre = Genre.find(params[:id])
		@vns = @genre.vns
	end

	def new
		@genre = Genre.new
		authorize @genre
	end
	def typeahead
	    @genre = Genre.search_by_name(params[:search])
	    @name = @genre.select('name').map(&:name)
	    render json: @name
 	 end

	def all
		@genres = Genre.all
	end

	def search
    	 @genres = Genre.search_by_name(params[:search])
	end

	def index
		@genres = Genre.limit(14).order("RANDOM()")
		
	end

	def edit
		@genre = Genre.find(params[:id])
		authorize @genre
	end

	def create	
    	@genre = Genre.new(char_params)  
    	if @genre.save
    		redirect_to genre_path(@genre)
    		flash[:success] = "Genre successfully created!"
    	else
    		render :action=>"new"
    	end

	end

	def update
		@genre = Genre.find(params[:id])
		authorize @genre
		if @genre.update(char_params)
			flash[:success] = "Your Genre was updated successfully!"
			redirect_to genres_path(@genre)
		else
			render :edit
		end
	end

	private
		def char_params
			params.require(:genre).permit(:name)
		end
end
