# == Schema Information
#
# Table name: users
#
#  id                :integer          not null, primary key
#  username          :string
#  email             :string
#  created_at        :datetime         not null
#  updated_at        :datetime         not null
#  password_digest   :string
#  remember_digest   :string
#  admin             :boolean          default(FALSE)
#  activation_digest :string
#  activated         :boolean          default(FALSE)
#  activated_at      :datetime
#  reset_digest      :string
#  reset_sent_at     :datetime
#
# Indexes
#
#  index_users_on_email     (email) UNIQUE
#  index_users_on_username  (username) UNIQUE
#

class User < ActiveRecord::Base

	attr_accessor :remember_token, :activation_token, :reset_token
	# downcase the email and username attributes before saving the user
	#before_save { self.email = email.downcase }
	before_save   :downcase_email
	#before_save { self.username = username.downcase }
	before_save   :downcase_username
	# Create an activation token and digest to each user object before it’s created
	before_create :create_activation_digest
	# Validates that :username is present and not over 50 characters long, and is unique.
	validates :username, presence: true, length: { maximum: 50 },
		# Test for case_sensitive and uniqueness. 
		# Rails infers that uniqueness should be true as well 
		uniqueness: { case_sensitive: false }
	# Only email addresses that match the pattern will be considered valid
 	VALID_EMAIL_REGEX = /\A[\w+\-.]+@[a-z\d\-]+(\.[a-z\d\-]+)*\.[a-z]+\z/i
 	# Validates that :email is present and not over 255 characters long, 
	validates :email, presence: true, length: { maximum: 255 },
	# uses regex pattern matching, and is unique.
	format: { with: VALID_EMAIL_REGEX },
	# Test for case_sensitive and uniqueness. 
	# Rails infers that uniqueness should be true as well 
	uniqueness: { case_sensitive: false }
	has_secure_password
	# The password should be present and have a minimum length, and allow nil
	# for updating the profile.
	validates :password, presence: true, length: { minimum: 6 }, allow_nil: true

	# Returns the hash digest of the given string.
 	# User.digest(string) is the clearest way to define it
 	# but it can be written as self.digest(string)
 	# it's used for minimum cost in the tests,
 	# and it is called from test/fixtures/users.yml
	def User.digest(string)
		cost = ActiveModel::SecurePassword.min_cost ? BCrypt::Engine::MIN_COST :
													  BCrypt::Engine.cost
		BCrypt::Password.create(string, cost: cost)
	end

	############### Create the remember token and remember digest ##############

	# With these two methods we've created a valid token and associated digest 
	# by first making a new remember token using User.new_token, 
	# and then updating the remember digest with the result of applying User.digest.

	# We need to create a random string of digits for use as a remember token.
	# This returns a random token for use in the remember method below
	# User.new_token is the clearest way to define it
 	# but it can be written as self.new_token 
  	def User.new_token
		SecureRandom.urlsafe_base64
	end

	# Remembers a user in the database for use in persistent sessions.
	def remember
		self.remember_token = User.new_token
		update_attribute(:remember_digest, User.digest(remember_token))
	end

	############################################################################

	# Returns true if the given token matches the digest.
	def authenticated?(attribute, token)
		digest = send("#{attribute}_digest")
		return false if digest.nil?
		BCrypt::Password.new(digest).is_password?(token)
	end

	# Forgets a user.
	def forget
		update_attribute(:remember_digest, nil)
	end

	# Activates an account.
	def activate
		update_attribute(:activated,    true)
		update_attribute(:activated_at, Time.zone.now)
	end

	# Sends activation email.
	def send_activation_email
		UserMailer.account_activation(self).deliver_now
	end

	# Sets the password reset attributes.
	def create_reset_digest
		self.reset_token = User.new_token
		update_attribute(:reset_digest,  User.digest(reset_token))
		update_attribute(:reset_sent_at, Time.zone.now)
	end

	# Sends password reset email.
	def send_password_reset_email
		UserMailer.password_reset(self).deliver_now
	end

	# Returns true if a password reset has expired.
	def password_reset_expired?
		reset_sent_at < 2.hours.ago
	end

	private

		# Converts email to all lower-case.
		def downcase_email
			self.email = email.downcase
		end

		# Converts username to all lower-case.
		def downcase_username
			self.username = username.downcase
		end

		# Creates and assigns the activation token and digest.
		def create_activation_digest
			self.activation_token  = User.new_token
			self.activation_digest = User.digest(activation_token)
		end

end
