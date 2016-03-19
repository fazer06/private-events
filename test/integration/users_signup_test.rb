require 'test_helper'

class UsersSignupTest < ActionDispatch::IntegrationTest

  def setup
    ActionMailer::Base.deliveries.clear
  end

	# Invalid Signup
	test "invalid signup information" do
	  # Visit the signup page
      get signup_path
      # Make sure there is no difference to the User model
      assert_no_difference 'User.count' do
      # Issue a post request with invalid signup information
      post users_path, user: { username:  "",
                               email: "user@invalid",
                               password:              "foo",
                               password_confirmation: "bar" }
    	end
    	# check the user’s new action is re-rendered
    	assert_template 'users/new'
    	# check the error explanation div is on the page
      	assert_select 'div#error_explanation'
      	# check the field_with_errors div is on the page
      	assert_select 'div.field_with_errors'
  	end

    # Valid signup
    test "valid signup information with account activation" do
      # Visit the signup page
      get signup_path
      # Make sure the User count has increased by 1
      assert_difference 'User.count', 1 do
      # Post with valid signup information
      post users_path, user: { username:  "jo",
                               email:     "jo@example.com",
                               password:  "password",
                               password_confirmation: "password" }
      end
      # This verifies that exactly 1 message was delivered
      assert_equal 1, ActionMailer::Base.deliveries.size
      # Lets us access @user in the the Users controller’s create action
      user = assigns(:user)
      # Is the user not activated
      assert_not user.activated?
      # Try to log in before activation.
      log_in_as(user)
      assert_not is_logged_in?
      # Invalid activation token
      get edit_account_activation_path("invalid token")
      assert_not is_logged_in?
      # Valid token, wrong email
      get edit_account_activation_path(user.activation_token, email: 'wrong')
      assert_not is_logged_in?
      # Valid activation token
      get edit_account_activation_path(user.activation_token, email: user.email)
      assert user.reload.activated?
      follow_redirect!
      assert_template 'users/show'
      assert is_logged_in?
    end

end
