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
#
# Indexes
#
#  index_events_on_creator_id  (creator_id)
#

class Event < ActiveRecord::Base

	belongs_to :creator, :class_name => "User"
	validates  :creator_id, 	presence: true
	validates  :location, 	presence: true, length: { maximum: 250 }
	validates  :description, presence: true

end
