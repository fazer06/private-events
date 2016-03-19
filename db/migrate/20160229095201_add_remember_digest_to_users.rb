class AddRememberDigestToUsers < ActiveRecord::Migration
  def change
  	# The random string of digits generated with SecureRandom.urlsafe_base64 
  	# was used by the remember method to create the hashed digest that's 
  	# stored in here.
    add_column :users, :remember_digest, :string
  end
end
