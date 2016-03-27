# == Schema Information
#
# Table name: event_attendees
#
#  id                :integer          not null, primary key
#  attendee_id       :integer
#  attended_event_id :integer
#  created_at        :datetime         not null
#  updated_at        :datetime         not null
#

class EventAttendee < ActiveRecord::Base

	# In our example of User and Event, the connection should be a EventAttendee.
	# This is the join table that holds the foreign keys  ...
	# attendee_id (User)
	# attended_event_id (Event)
	# connecting to one row from events and one row from users.

	# Normally if a User has_many :events the Event would belongs_to :user
	# so the Event table would have the foreign key user_id. 
	
	# However, Event also has_many :attendees, through: :event_attendees
	# because it's this table (the join table) that belongs_to :attendee 
	# so this table holds the attendee_id (User)

	# Also, the Event has_many :event_attendees, :foreign_key => :attended_event_id 
	# because this join table holds the attended_event_id (Event)

	# Our example also has the normal associations, a User and a Event
	# has_many :event_attendees and as you can see, EventAttendee belongs_to both
	# attended_event (an event) and attendee (a user).

	# Why does this happen ? 
	# Using "has many through", Rails can hop across the intermediary relationship. 
	# We can now call @user.attended_events when we want to work with (go through) the join,
	# and @user.event_attendees when we don’t want to go through

	# In the console

	# u = User.first (Grab the first user)
	# u.events.count ( Return the number of events )
	# u.events ( Grab that users events )

	# u.attended_events (Grab all events that user is going to - USING the join )
	# u.event_attendees ( Returns the event and user id's NOT using the join )

	# Similarly, @event.attendees when we want to work with the join 
	# and @event.event_attendees when we don’t.

	# e = Event.first (Grab the first event)
	# e.attendees (Grab events attendees (returns user objects) - GOING THROUGH the join )
	# e.event_attendees ( Returns the event and user id's NOT GOING through the join )
	# e.attendees.find(2).username  (Return the username of the user going to that event) 
	# e.creator ( The user object that created the event )
	# e.creator.username ( Pull out the creator username from the user object )

	# A shorter way to get the event's creator and attendees 
	# The attendees loop is GOING THROUGH the join
	
	# e = Event.last
	# e.creator.username
	# e.attendees.each { |a| puts a.username }

	# Looking at the upcoming and past scopes

	# e = Event.all (Grab all the events)
	# e.upcoming ( list all upcoming events )
	# e.past ( list all past events )

	# ------------------------------------------------------------------

	# The EventAttendee model brings the User and Event models together, 
	# where a user can have (attend) many events, and events can have many 
	# users (attendees).
	# It's this join table that pulls (or joins ) our associations together. 

	# So, it's the attendee_id that holds (points to) the user id
	belongs_to :attendee, :class_name => "User"
	# and, it's the attended_event_id that holds (points to) the event id
	belongs_to :attended_event, :class_name => "Event"

	validates :attendee_id, presence: true
	validates :attended_event_id, presence: true
	
end
