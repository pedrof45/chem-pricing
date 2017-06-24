class PackagingPolicy < ApplicationPolicy

def index?
    user.admin_or_more?
  end




end
