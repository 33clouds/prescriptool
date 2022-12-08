require "rqrcode"

class PrescriptionsController < ApplicationController
  def index
    @prescriptions = policy_scope(Prescription)
    @prescriptions = current_user.prescriptions_as_patient
  end

  def show
    @prescription = current_user.prescriptions_as_patient.find(params[:id])
    authorize @prescription
    createqr_code(create_string(@prescription))
    # qrcode = RQRCode::QRCode.new("#{request.base_url}/prescriptions/#{@prescription.id}")
  end

  private

  def create_string(prescription)
    data_array = ""
    data_array += "#{prescription.created_at.strftime('%a %d %b %Y')}\n"
    data_array += "Dr #{prescription.professional.last_name}\n"
    data_array += "Patient: #{prescription.patient.first_name} #{prescription.patient.last_name}\n"
    prescription.meds.each do |med|
      data_array += "#{med.name}: "
      med.meds_prescriptions.each do |meds_prescription|
        data_array += "#{meds_prescription.dosage}\n"
      end
    end
    data_array
  end

  def createqr_code(data_array)
    qrcode = RQRCode::QRCode.new(data_array)
    @svg = qrcode.as_svg(
      color: "000",
      shape_rendering: "crispEdges",
      module_size: 11,
      standalone: true,
      use_path: true
    )
  end
end
