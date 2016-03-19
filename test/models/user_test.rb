require 'test_helper'

class UserTest < ActiveSupport::TestCase

	def setup
		@user = User.new(username: "Example User", email: "user@example.com",
                     	 password: "foobar", password_confirmation: "foobar")
	end

	# Is the user valid
	test "should be valid" do 
		assert @user.valid? # assert it's a valid user object
	end

	# The username attribute should be present
	test "username should be present" do 
		@user.username = "    " 
		assert_not @user.valid? # assert_not (assert its NOT valid) without a username
	end

	# The email attribute should be present
	test "email should be present" do 
		@user.email = "    "
		assert_not @user.valid?
	end

	# Maximum length of 50 characters for the user name
	test "username should not be too long" do 
		@user.username = "a" * 51
		assert_not @user.valid?
	end

	# Maximum length of 255 characters for the users email
	test "email should not be too long" do 
		@user.email = "a" * 244 + "@example.com"
		assert_not @user.valid?
	end

	# All email address should be valid email address
	test "email validation should accept valid addresses" do
		valid_addresses = %w[user@example.com USER@foo.COM A_US-ER@foo.bar.org
		                     first.last@foo.jp alice+bob@baz.cn]
		valid_addresses.each do |valid_address|
			@user.email = valid_address
			assert @user.valid?, "#{valid_address.inspect} should be valid"
		end
	end

	# Test for invalid email addresses
	test "email validation should reject invalid addresses" do
		invalid_addresses = %w[user@example,com user_at_foo.org user.name@example.
	                           foo@bar_baz.com foo@bar+baz.com]
		invalid_addresses.each do |invalid_address|
		  @user.email = invalid_address
		  assert_not @user.valid?, "#{invalid_address.inspect} should be invalid"
		end
	end

	# The email and username should be unique
	test "email addresses and username should be unique" do
		duplicate_user = @user.dup
		duplicate_user.email = @user.email.upcase
		duplicate_user.username = @user.username.upcase
		@user.save
		assert_not duplicate_user.valid?
	end

	# email addresses should be saved as lowercase
	test "email addresses should be saved as lower-case" do
		mixed_case_email = "Foo@ExAMPle.CoM"
		@user.email = mixed_case_email
		@user.save
		assert_equal mixed_case_email.downcase, @user.reload.email
	end

	# usernams should be saved as lowercase
	test "usernames should be saved as lower-case" do
		mixed_case_username = "ExAMPle UsEr"
		@user.username = mixed_case_username
		@user.save
		assert_equal mixed_case_username.downcase, @user.reload.username
	end

	# The password should be present
	test "password should be present (nonblank)" do
		@user.password = @user.password_confirmation = " " * 6
		assert_not @user.valid?
	end

	# The password should have a minimum length
	test "password should have a minimum length" do
		@user.password = @user.password_confirmation = "a" * 5
		assert_not @user.valid?
	end

	# Start with a user that has no remember digest, and then call authenticated?
	test "authenticated? should return false for a user with nil digest" do
		assert_not @user.authenticated?(:remember, '')
	end

end
