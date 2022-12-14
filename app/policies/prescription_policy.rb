class PrescriptionPolicy < ApplicationPolicy
  class Scope < Scope
    # NOTE: Be explicit about which records you allow access to!
    def resolve
      scope.where(patient: user)
    end
  end

  def show?
    record.patient == user || record.professional == user
  end

  def qr?
    show?
  end

  def archive?
    show?
  end

  def archived?
    record.each do |r|
      return false unless r.patient == user || r.professional == user
    end
    return true
  end

  def new?
    create?
  end

  def create?
    @user.pro?
  end
end
