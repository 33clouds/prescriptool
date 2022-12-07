class PrescriptionsController < ApplicationController
  def index
    @prescriptions = policy_scope(Prescription)
    @prescriptions = current_user.prescriptions_as_patient
  end

  def show
    @prescription = current_user.prescriptions_as_patient.find(params[:id])
    authorize @prescription
  end
end
