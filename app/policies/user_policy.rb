class UserPolicy < ApplicationPolicy
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
        scope.where(:id => user.id)
      end
    end
  end

    def index?

      if user.sysadmin_or_more?
        true
      else
        @users = UserPolicy::Scope.new(@user,User).resolve
      end
    
    end

    def update?
  	 if record.sysadmin_or_more?
  		user.sysadmin_or_more?
  	elsif record.admin_or_more?
  		sysadmin_or_more_or_self
  	elsif record.manager_or_more?
  		sysadmin_or_more_or_self
  	else 
  		sysadmin_or_more_or_self
  	end
   end

    def create?
      user.sysadmin_or_more?
    end

    def destroy?
      user.sysadmin_or_more?
    end

     def show?
      user.sysadmin_or_more?
    end
end
