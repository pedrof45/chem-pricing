class UserPolicy < ApplicationPolicy

  def index?
  scope.where(:id => record.id=user.id)
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
