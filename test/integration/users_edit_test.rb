require 'test_helper'

class UsersEditTest < ActionDispatch::IntegrationTest

	def setup
		@user = users(:fazer)
	end

	# Test a unsuccessful edit of the users profile
	test "unsuccessful edit" do
		# Edit and Update actions require a logged-in user
		log_in_as(@user)
		# GET the correct URL for the user
		get edit_user_path(@user)
		# Check the edit template is rendered 
		assert_template 'users/edit'
		# Pass the information the user would submit on the form
		patch user_path(@user), user: 	{ 	name: "",
										 	email: "foo@invaled",
										 	password: "foo",
										 	password_confirmation: "bar"	}
		# Check the edit template is rendered
		assert_template 'users/edit'
	end

	# Test for a successful edit
	test "successful edit with friendly forwarding" do
		# Visit the users edit page
		get edit_user_path(@user)
		# Make sure the session variable key :forwarding_url IS NOT nil
		assert_not_nil session[:forwarding_url]
		# Then login the user
		log_in_as(@user)
		# Then check the user is redirected to the edit page instead 
		# of the default profile page.
		assert_redirected_to edit_user_path(@user)
		# Pass the information the user would submit on the form
		username  = "fazer"
		email = "foo@bar.com"
		patch user_path(@user), user: { name:  username,
		                                email: email,
		                                password:              "",
		                                password_confirmation: "" }
		# Check for a nonempty flash message
		assert_not flash.empty?
		# Check for a successful redirect to the profile page, 
		# with updated information in the database
		assert_redirected_to @user
		# IS session variable key :forwarding_url NIL after a redirect?
		assert_nil session[:forwarding_url]
		# Reload the user’s values from the database and confirm 
		# that they were successfully updated
		@user.reload
		# Make sure the username matches
		assert_equal username,  @user.username
		# Make sure the email matches
		assert_equal email, @user.email
	end

end
