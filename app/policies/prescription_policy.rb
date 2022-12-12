class PrescriptionPolicy < ApplicationPolicy
  class Scope < Scope
    # NOTE: Be explicit about which records you allow access to!
    def resolve
      scope.where(patient: user)
      # scope.all
    end
  end

  def show?
    true
  end

  def archive?
    show?
  end

  def archived?
    show?
  end

  def new?
    create?
  end

  def create?
    @user.pro?
  end
end
