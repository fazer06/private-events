class UsersController < ApplicationController

	# User must be logged in to edit and update their account.
	before_action :logged_in_user, 	only: [:index, :edit, :update, :destroy]
	# ONLY the CORRECT user can edit and update their OWN account settings.
	before_action :correct_user, 	only: [:edit, :update]
	before_action :admin_user,      only: :destroy

	def index 
		@users = User.paginate(page: params[:page])
	end

	def show
		@user = User.find(params[:id])
	end

	def new
		@user = User.new
	end

	def create
		@user = User.new(user_params)
		if @user.save
			# Deliver the activation email to the user
			@user.send_activation_email
			# Flash a message to the user after sign-up
			flash[:info] = "Please check your email to activate your account."
			# Redirect to the root url
			redirect_to root_url
		else
			render 'new'
		end
	end

	def edit
		
	end

	def update
		if @user.update_attributes(user_params)
			# Flash a message that the profile was updated
			flash[:success] = "Your profile was updated!"
			# Redirect to the user profile page
			redirect_to @user
		else
			# Display edit page if update wasn't successful
			render 'edit'
		end
	end

	def destroy
		User.find(params[:id]).destroy
		flash[:success] = "User deleted"
		redirect_to users_url
	end

	private

		def user_params
			params.require(:user).permit( :username, 
										  :email, 
										  :password, 
										  :password_confirmation )
		end

	    # Before filters

		# Confirms a logged-in user.
		def logged_in_user
			unless logged_in?
				# Calls store location in app/helpers/sessions_helper.rb
				store_location
				flash[:danger] = "Please log in."
				redirect_to login_url
			end
		end

		# Confirms an admin user
		def admin_user
			redirect_to(root_url) unless current_user.admin?
		end

		# Only the correct user can edit and update their own account settings
		def correct_user
			@user = User.find(params[:id])
			redirect_to(root_url) unless current_user?(@user)
		end

end
