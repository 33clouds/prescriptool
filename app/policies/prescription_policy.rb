class PrescriptionPolicy < ApplicationPolicy
  class Scope < Scope
    # NOTE: Be explicit about which records you allow access to!
    def resolve
      scope.where(patient: user)
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

  # def search?
  #   show?
  # end
end
