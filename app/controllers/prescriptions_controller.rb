class PrescriptionsController < ApplicationController
  def index
    @prescriptions = policy_scope(Prescription)
    # @doc_p = @prescriptions.where()
  end

  def show
    @prescription = Prescription.find(params[:id])
    authorize @prescription
  end
end
