class QuotePolicy < ApplicationPolicy


	def index?
		#FIX
	  @quotes = @user.quotes
	end

end
