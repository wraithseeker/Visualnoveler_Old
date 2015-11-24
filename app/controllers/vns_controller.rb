class VnsController < ApplicationController
	include VnsHelper
	before_action :authenticate_user!, :only => [:edit,:crop,:new,:update]
	def show
		@vn = Vn.find(params[:id])
		@showcharacters = @vn.characters.all
		@screenshots = @vn.screenshots
	end

	def rate
		@vn = Vn.find(params[:id])
		type = params[:rating]
		if type == "perfect"
			# perfect = 10, great = 8 , good = 6 , awful = 4
			rate_vn(10)
		elsif type =="great"
			rate_vn(8)
		elsif type =="good"
			rate_vn(6)
		elsif type =="awful"
			rate_vn(4)
		else
			redirect_to :back, notice: 'Nothing happened, perhaps a bug?'
		end
	end

	def edit
		@vn = Vn.find(params[:id])
		authorize @vn
		@character = @vn.characters
    	#@vn.characters.build
	end
# add to library entries favourite
	def favourite
		@vn = Vn.find(params[:id])
		type = params[:type]
		libentry = current_user.library_entries.find_or_create_by(vn_id: @vn.id)
		if type == "favourite" 
			libentry.update_attribute(:favourite,true)
			post = libentry.posts.build(detail: "#{current_user.name} has recently added #{@vn.name} to his favourites.",user_id: current_user.id)
			if post.save 
				redirect_to :back
				flash[:success] = post.detail
			end
		elsif type == "unfavourite"
			libentry.update_attribute(:favourite,false)
			post = libentry.posts.build(detail: "#{current_user.name} has recently removed #{@vn.name} from his favourites.",user_id: current_user.id)
			if post.save 
				redirect_to :back
				flash[:success] = post.detail
			end
		else
			redirect_to :back, notice: 'Nothing happened, perhaps a bug?'
		end
	end

# add to library entries Status (Watching/Dropped/Wishlist)
	def status
		@vn = Vn.find(params[:id])
		type = params[:type]
		libentry = current_user.library_entries.find_or_create_by(vn_id: @vn.id)
		 if type == "watch" 
			libentry.update_attribute :status, "watch"
			post = libentry.posts.build(detail: "#{current_user.name} has started watching #{@vn.name}",user_id: current_user.id)
		elsif type == "drop"
			libentry.update_attribute :status, "drop"
			post = libentry.posts.build(detail: "#{current_user.name} has dropped #{@vn.name} from his library",user_id: current_user.id)
		elsif type == "wishlist"
			libentry.update_attribute :status, "wishlist"
			post = libentry.posts.build(detail: "#{current_user.name} has added #{@vn.name} to his wishlist",user_id: current_user.id)
		elsif type =="complete"
			libentry.update_attribute :status, "complete"
			post = libentry.posts.build(detail: "#{current_user.name} has completed #{@vn.name}",user_id: current_user.id)
		end
		if post.save 
			redirect_to :back
			flash[:success] = post.detail
		else
			redirect_to :back
			flash[:danger] = "There is a bug with VN Status code"
		end
	end

	def index
		@vn = Vn.all
		#@vn = Vn.all.where(:isFeatured => true)
		#offset = rand(Vn.count)
		@random = Vn.limit(5).order("RANDOM()")
	end

	def new
		@vn = Vn.new
		authorize @vn
    	@vn.characters.build
	end

	def update
		@vn = Vn.find(params[:id])
		authorize @vn
		if @vn.update(vn_params)
			
			flash[:success] = "Visual Novel is updated successfully!"
			redirect_to vn_path(@vn)
			#redirect_to recipe_path(@recipe)
		else
			flash[:danger] = "failed"
			render :edit
		end
	end

	def crop
		@vn = Vn.find(params[:id])
		authorize @vn
		if @vn.save
			render :crop
		end
		 
	end

	def characters
		@vn = Vn.find(params[:id])
		@characters = @vn.characters
	end

	def screenshots
		@vn = Vn.find(params[:id])
		@vn.screenshots.build
		authorize @vn
	end

	def create	
    	@vn = Vn.new(vn_params) 
    	authorize @vn 
    	if @vn.save
    		 redirect_to vn_path(@vn)
    		 flash[:success] = "Visual novel successfully created!"
    	else
    		render :action=>"new"
    	end

	end

	private

		def vn_params
			params.require(:vn).permit(:name,:remote_image_1_url,:remote_image_2_url,:remote_image_3_url,:remote_image_4_url,
			:bio,:trailer_url,:image_coverpage_crop_x,:image_coverpage_crop_y, :image_coverpage_crop_w, :image_coverpage_crop_h,:rating_number,:isFeatured,
			 { characters_attributes: [:id,:_destroy,:name,:summary,:voiceactor,:remote_img_string_url,:img_string,] },:release_date, :summary,:genre_old,
			 { :genre_ids => [] },:developer_id,:vn_id,:image_poster,:image_coverpage,:image_1,:image_2,:image_3,:image_4,:genre_id,
			 {screenshots_attributes: [:id,:_destroy,:name,:alt,:image] } ,:remote_image_poster_url)
		end

end
