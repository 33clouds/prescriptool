class PrescriptionPolicy < ApplicationPolicy
  class Scope < Scope
    # NOTE: Be explicit about which records you allow access to!
    def resolve
      scope.where(patient: user)
      # scope.all
    end
  end

  def show?
    user == self.user
  end
end
