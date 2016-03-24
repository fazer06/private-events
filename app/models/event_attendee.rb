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

	# The EventAttendee model brings the User and Event models together, 
	# where a user can have (attend) many events, and events can have many 
	# users (attendees).
	# It's this join table that pulls (or joins ) our associations together. 

	# So, it's the attendee_id = that holds (or points to) the user id
	belongs_to :attendee, :class_name => "User"
	# and, it's the attended_event_id = holds (or points to) the event id
	belongs_to :attended_event, :class_name => "Event"

	validates :attendee_id, presence: true
	validates :attended_event_id, presence: true
	
end
