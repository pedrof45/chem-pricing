class UserPolicy < ApplicationPolicy

def index?
    user.owner?
  end




end
