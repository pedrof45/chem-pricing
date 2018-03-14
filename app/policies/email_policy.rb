class EmailPolicy < ApplicationPolicy
  class Scope < Scope
    attr_reader :user, :scope

    def initialize(user,scope)
      @user = user
      @scope = scope
    end

    def resolve
      if user.manager_or_more?
        scope.all
      else
        scope.where(user: (user.supervised + [user]))
      end
    end
  end
end