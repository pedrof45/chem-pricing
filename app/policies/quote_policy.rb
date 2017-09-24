class QuotePolicy < ApplicationPolicy
	class Scope < Scope
	    attr_reader :user, :scope

	    def initialize(user,scope)
	      @user =user
	      @scope =scope
	      
	    end

	    def resolve
	      if user.sysadmin_or_more?
	        scope.all
	      else
	        scope.where(:user_id => user.id)
	      end
	    end
	  end

	def index?
      if user.manager_or_more?
        true
      else
        @quotes = UserPolicy::Scope.new(@user,Quote).resolve
      end
	end

	def unwatch?
		update?
	end

	def update?
		owner? || user.manager_or_more?
	end
end
