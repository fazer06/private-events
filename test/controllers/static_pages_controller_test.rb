require 'test_helper'

class StaticPagesControllerTest < ActionController::TestCase

	# This tests verifies that the controller action home can be accessed using 
	# a GET request, and the page (the view) can be successfully displayed
	test "should get home" do
		# Issue a GET request to the StaticPagesController home action
		get :home
		# The response :success is a representation of the underlying HTTP 
		# status code (in this case, 200 OK)
		assert_response :success
		assert_select "title", full_title("Home")
	end

	test "should get help" do
		get :help
		assert_response :success
		assert_select "title", full_title("Help")
	end

	test "should get about" do 
		get :about
		assert_response :success
		assert_select "title", full_title("About")
	end

end
