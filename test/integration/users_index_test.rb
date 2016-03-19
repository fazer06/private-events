require 'test_helper'

class UsersIndexTest < ActionDispatch::IntegrationTest

	# Set the users up
	def setup
		@admin = 	 users(:fazer)
		@non_admin = users(:kim)
	end

	# Admin test for verifying the index, pagination, and delete links are working
	test "index as admin including pagination and delete links" do
		# Login as an admin user
		log_in_as(@admin)
		# Get the user path
		get users_path
		# Assert that the users 'index' was rendered
		assert_template 'users/index'
		# Check for a div with the pagination class 
		assert_select 'div.pagination'
		# Check that the first page of users is present
		first_page_of_users = User.paginate(page: 1)
		# Loop through the first page of users
		first_page_of_users.each do |user|
			# Verify that the user link works
			assert_select 'a[href=?]', user_path(user), text: user.username
			unless user == @admin
				# Verify that the delete link works
				assert_select 'a[href=?]', user_path(user), text: 'delete'
			end
		end
		# verify that a user gets deleted when an admin clicks on a delete link
		assert_difference 'User.count', -1 do
			delete user_path(@non_admin)
		end
	end

	# Check the users index page for delete links for a non-admin user
	test "index as non-admin" do
		# Login as a standard user
		log_in_as(@non_admin)
		# get the users path
		get users_path
		# verify that the count hasn't changed
		assert_select 'a', text: 'delete', count: 0
	end

end
