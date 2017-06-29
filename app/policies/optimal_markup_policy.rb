class OptimalMarkupPolicy < ApplicationPolicy
	
  def index?
    user.manager_or_more?
  end

  

 




end
