require 'test_helper'

class UsersControllerTest < ActionController::TestCase

	# Set up the user from the test/fixtures/users.yml
	def setup
		@user = users(:fazer)
		@other_user = users(:renee)
	end

	# Should redirect the index if you're NOT logged in
	test "should redirect index when not logged in" do 
		get :index
		assert_redirected_to login_url
	end

	# Test the new action for a new user
	test "should get new" do
		get :new
		assert_response :success
	end

	# Should redirect edit when not logged in
	test "should redirect edit when not logged in" do
		# id: @user, which (as in the controller redirects) automatically uses @user.id
		get :edit, id: @user
		# Check if the flash is empty
		assert_not flash.empty?
		# Redirect to the login url
		assert_redirected_to login_url
	end

	# Should redirect update when not logged in
	test "should redirect update when not logged in" do
		# Same as above but with an additional user hash in order for the routes to work properly
		patch :update, id: @user, user: { username: @user.username, email: @user.email }
		# Check if the flash is empty		
		assert_not flash.empty?
		# Redirect to the login url
		assert_redirected_to login_url
	end

	# Redirect edit when logged in as wrong user
	test "should redirect edit when logged in as wrong user" do
		# Login as the other (wrong) user
		log_in_as(@other_user)
		get :edit, id: @user
		# Check if the flash is empty
		assert flash.empty?
		# Redirect to the root url
		assert_redirected_to root_url
	end

	# Redirect update when logged in as wrong user
	test "should redirect update when logged in as wrong user" do
		# Login as the other (wrong) user
		log_in_as(@other_user)
		patch :update, id: @user, user: { username: @user.username, email: @user.email }
		# Check if the flash is empty
		assert flash.empty?
		# Redirect to the root url
		assert_redirected_to root_url
	end

	# Make sure the admin attribute can NOT be edited via the web
	test "should not allow the admin attribute to be edited via the web" do
		# Login as the other (non-admin) user
		log_in_as(@other_user)
		# Make sure the other user is a non-admin user
		assert_not @other_user.admin?
		# Try to update the admin attribute
		patch :update, id: @other_user, user: { password: 'password',
		password_confirmation: 'password',
		admin: true }
		# Make sure the other user is still NOT an admin user
		assert_not @other_user.reload.admin?
	end

	# Users who aren’t logged in should be redirected to the login page
	test "should redirect destroy when not logged in" do
		# Make sure that the user count doesn’t change
		assert_no_difference 'User.count' do
			# Use delete to issue a DELETE request directly to the destroy action
			delete :destroy, id: @user
		end
		# Redirected to the login page
		assert_redirected_to login_url
	end

	# Users who are logged in but who aren’t admins should be redirected to the Home page
	test "should redirect destroy when logged in as a non-admin" do
		# login as a non-admin user
		log_in_as(@other_user)
		# Make sure that the user count doesn’t change
		assert_no_difference 'User.count' do
			# Use delete to issue a DELETE request directly to the destroy action
			delete :destroy, id: @user
		end
		# Redirected to the Home page
		assert_redirected_to root_url
	end

end
