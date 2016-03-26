# == Schema Information
#
# Table name: events
#
#  id          :integer          not null, primary key
#  location    :string
#  date        :date
#  created_at  :datetime         not null
#  updated_at  :datetime         not null
#  creator_id  :integer
#  description :text
#  title       :string
#
# Indexes
#
#  index_events_on_creator_id  (creator_id)
#

class Event < ActiveRecord::Base

	# In the User model we created the has_many relationship between the User 
	# and this Event model, which belongs_to a creator which is really just a User. 
	# It works because Rails knows to look for the creator_id field in the events 
	# table, which holds the user_id when you include the line below:

	belongs_to 	:creator, :class_name => "User"
	
	# The next two has many associations point to the join table, event_attendees.
	# An Event has many Users (attendees), through event attendees.

	# Note that the EventAttendee model allows us to have two has_many relationships: 
	# a user has many events, and an event has many users.

	has_many 	:attendees, :through => :event_attendees
	has_many 	:event_attendees, :foreign_key => :attended_event_id


	# We use scopes to query for upcoming and past events in our application. 
	# We use these scopes in some of the methods defined in the User model, 
	# to pull a specific user's upcoming and past events

	scope :upcoming, -> { where("Date >= ?", Date.today).order('Date ASC') }
	scope :past, 	 -> { where("Date <  ?", Date.today).order('Date DESC') }

	# In the console these will return ActiveRecord::Relation
	# e = Event.all
	# e.upcoming
	# e.past

	validates  :creator_id,  presence: true
	validates  :location, 	 presence: true, length: { maximum: 100 }
	validates  :location, 	 presence: true, length: { maximum: 250 }
	validates  :description, presence: true

end
