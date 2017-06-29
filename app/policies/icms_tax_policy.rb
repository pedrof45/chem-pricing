class IcmsTaxPolicy < ApplicationPolicy


def index?
    user.manager_or_more?
  end

 def create?
    user.admin_or_more?
  end

  def update?
    user.admin_or_more?
  end

  def destroy?
    user.admin_or_more?
  end

end
