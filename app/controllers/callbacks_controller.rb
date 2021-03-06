class CallbacksController < Devise::OmniauthCallbacksController
    def facebook
        @user = User.from_omniauth(request.env["omniauth.auth"])
	    if @user.persisted?
	      sign_in_and_redirect @user, :event => :authentication #this will throw if @user is not activated
	      set_flash_message(:notice, :success, :kind => "Facebook") if is_navigational_format?
	    else
	      session["devise.facebook_data"] = request.env["omniauth.auth"]
	      redirect_to register_path
	    end
    end

    def google_oauth2
        @user = User.from_omniauth(request.env["omniauth.auth"])
	    if @user.persisted?
	      flash[:notice] = I18n.t "devise.omniauth_callbacks.success", :kind => "Google"
	      sign_in_and_redirect @user, :event => :authentication
	    else
	      session["devise.google_data"] = request.env["omniauth.auth"]
	      redirect_to register_path
	    end
	end


    def twitter
    	auth = request.env["omniauth.auth"]
        @user = User.where(provider: auth.provider, uid: auth.uid).first_or_create
        if @user.persisted?
	        flash[:notice] = I18n.t "devise.omniauth_callbacks.success", :kind => "Twitter"
	        sign_in_and_redirect @user, :event => :authentication
	    else
	    	@form = TwitterForm.new 
        	session["devise.twitter_data"] = request.env["omniauth.auth"].except("extra")
        	render :layout => 'none'
	    end
	end

    def failure
    	redirect_to root_path
  	end
end