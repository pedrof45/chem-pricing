class UserPolicy < ApplicationPolicy

  def index?
    user.sysadmin_or_more?
  end

end
