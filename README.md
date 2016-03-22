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

### (1) Build and migrate your Event model

- rails generate model Events location:string date:date