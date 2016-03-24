class CreateEventAttendees < ActiveRecord::Migration
  def change
    create_table :event_attendees do |t|
      t.integer :attendee_id
      t.integer :attended_event_id

      t.timestamps null: false
    end
  end
end
