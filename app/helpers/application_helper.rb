module ApplicationHelper

	# The full title helper returns the page title on a per page basis
	
	# Define the full_title method and pass it the page_title argument
	# The page_title variable has a default value of an empty string
	def full_title(page_title = '') 
		# Define the base_title variable
		base_title = "Site Name Here"
		# Boolean test
		if page_title.empty?
			# Return the base title (return is optional, we can just use base_title)
			return base_title
		else
			# Return the page_title with string concatenation and the base_title
			return page_title + " | " + base_title
		end
	end


    # Change the value below between the quotes.
	def meta_viewport
    	"width=device-width, initial-scale=1"
  	end

    # Change the value below between the quotes.
	def meta_author
    	"Website Author. Find me in application_helper.rb"
  	end

    # Change the value below between the quotes.
	def meta_description
		"Add your website description here. Find me in application_helper.rb"
	end

    # Change the value below between the quotes.
	def meta_keywords
		"Add your keywords here. Find me in application_helper.rb"
	end

	# http://api.rubyonrails.org/classes/ActionView/Helpers/DateHelper.html#method-i-date_select
	def get_date_time() 
		my_date = Time.now
  	end

  	# Displays a morning, afternoon, or evening message
  	def get_time_message()
		t = Time.now
		#string_date = t.strftime("%A %B %d, %Y")

		if t.hour < 12
			time_message =	"Good Morning"
		elsif t.hour > 12 && t.hour < 17 
			time_message =	"Good Afternoon"
		else
			time_message =	"Good Evening"
		end
  	end

	# Copyright Notice, with year range
	def copyright_notice_year_range(start_year)
		# In case the input was not a number (nil.to_i will return a 0)
		start_year = start_year.to_i

		# Get the current year from the system
		current_year = Time.new.year

		# When the current year is more recent than the start year, return a string 
		# of a range (e.g., 2010 - 2012). Alternatively, as long as the start year 
		# is reasonable, return it as a string. Otherwise, return the current year 
		# from the system.
		if current_year > start_year && start_year > 2000
			"#{start_year} - #{current_year}"
		elsif start_year > 2000
			"#{start_year}"
		else
			"#{current_year}"
		end
	end

	# Output what season it is based on the month
	def get_season()
		time = Time.new

		if(time.month >= 3) && (time.month <= 5)
				season_type = "Yeah it is Spring"
			elsif (time.month > 5) && (time.month <= 8)
				season_type = "Everyone Loves Summer"
			elsif (time.month > 8) && (time.month <= 10)
				season_type = "Put on Your Coat because Autumn is here"
			else
				season_type = "Yuck, it's now Winter"
		end
	end

  	# A random welcome message for the home page jumbotron
	def get_random_message()
		opening = [ "Developer Portfolio",
            		"My Rails 4 Portfolio",
            		"Hello World" ]

		middle = [  "Built from the Rails Tutorial",
            		"Rails Apps Are Great",
            		"Rails Twitter clone App" ]

		ending = [  "Contact us if you need help.",
            		"We are here to server you. ",
            		"Call us if you need to 412-555-1212."]

		"#{opening[rand(3)]}"

	end

end