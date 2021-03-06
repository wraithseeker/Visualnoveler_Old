class Character < ActiveRecord::Base
	validates :name, :presence => true
	#validates :vn_id, :presence => true 
	#maybe we will validate vn_id one day, for now enabling it causing VN creation to be bugged because it does not exist
	# validates :summary, :presence => true
	has_many :character_vns,dependent: :destroy	
	has_many :vns, :through => :character_vns
	#belongs_to :vn
	mount_uploader :img_string, ScreenshotUploader
	#note to self this is a "HACK" to get nested fields working, fix this when u can
	crop_uploaded :image_coverpage  

	enum role: {"Not Set" => 0,"Main" => 1,"Supporting" => 2,"Protagonist" => 3}
	include PgSearch
	pg_search_scope :search_by_name, :against => :name,:using => {
	            :tsearch => {:prefix => true}
	          }
    def self.priority_order
	    order("CASE role
	      WHEN 3 THEN 0
	      WHEN 1 THEN 1
	      WHEN 2 THEN 2
	      WHEN 0 THEN 3 
	    END")
  	end

end