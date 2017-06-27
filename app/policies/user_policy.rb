class UserPolicy < ApplicationPolicy

  def index?
    user.admin_or_more?
  end

end
