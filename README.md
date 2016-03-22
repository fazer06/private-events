# The Odin Project - Ruby on Rails
## Project: Associations - Private Events 

A walkthrough of my latest Odin Project app, Private Events.

### Our Objective:

We have to build a site similar to a Eventbrite which allows users to create events and then manage user signups. I must be honest, I decided to cheat a little with this project and completely miss out the first part which was to setup the sign-in mechanism. I started with a copy and paste from our build of the rails tutorial up-to chapter 10. The reason I did this was I wanted to create a proper full featured application that I could use in production, so i wanted to save some time.

### Features

- A user can register for an account
- A user can login and logout
- A user can change their details
- Google Analytics Integration

## Basic Events

### Step 1 Build and migrate your Event model

- rails generate model Event location:string date:date
- bundle exec rake db:migrate

### Step 2 Associations between the User and Event

    Add the association between the event creator (a User) and the event. 
    Call this user the "creator".

### In app\models\event.rb
- belongs_to :creator, :class_name => "User"

### In app\models\user.rb
- has_many :events, :foreign_key => :creator_id

### Add the foreign key to the Events model
- rails generate migration add_creator_to_events creator_id:integer

### Also add the index to the migration
- add_index  :events, :creator_id
- bundle exec rake db:migrate

### Step 3 User's Show page to list all users events

		<% if @user.events.any? %>
			<h3>Submitted (<%= @user.events.count %>) events</h3>
			<ul class="media-list">
				<%= render @events %>
			</ul>
			<%= will_paginate @events %>
		<% else %>
			<h3>No Events Found</h3>
		<% end %>

### Renders event from app/views/events/_event.html.erb

	<li class="media">
		<div class="media-left">
			<a href="#"><%= gravatar_for user, size: 50 %></a>
		</div>
		<div class="media-body">
			<h4 class="media-heading">Media heading</h4>
		</div>
	</li>

### Step 4 Create the  Events Controller and routes

- rails generate controller Events

### Steps 5, 6, 7, and 8

- For steps 5 to 8
- rails generate migration add_desc_to_events description:text
- bundle exec rake db:migrate
- Do all the normal CRUD actions and views.