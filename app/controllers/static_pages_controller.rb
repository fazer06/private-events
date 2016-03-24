class StaticPagesController < ApplicationController

	def home
		@events = Event.all.paginate(page: params[:page])
	end

	def help
	end

	def about
	end
  
end
