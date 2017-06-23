class BusinessUnitPolicy < ApplicationPolicy

	def index?
    user.owner?
  end

end
