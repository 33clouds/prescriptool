require "rqrcode"

class PrescriptionsController < ApplicationController
  before_action :find_by_id, only: [:show, :archive]

  def index
    if params[:query].present?
    else
      @prescriptions = policy_scope(Prescription)
      @prescriptions = current_user.prescriptions_as_patient.active
    end
  end

  def show
    authorize @prescription
    createqr_code(create_string(@prescription))
    # qrcode = RQRCode::QRCode.new("#{request.base_url}/prescriptions/#{@prescription.id}")
  end

  def archive
    authorize @prescription
    @prescription.update(prescription_params)
    redirect_to archived_prescriptions_path, notice: "Prescription scanned!"
  end

  def archived
    @prescriptions = current_user.prescriptions_as_patient.archived
    authorize @prescriptions
  end

  def search
    @query = params[:query]
    @results = PgSearch.multisearch(@query)
    @prescriptions = []
    @prescriptions = policy_scope(Prescription)
    @prescriptions = current_user.prescriptions_as_patient.active
    @results.each do |result|
      if result.searchable_type == "User"
        @prescriptions = result.searchable.prescriptions_as_professional
        # authorize @prescriptions
      else
        @prescriptions = result.searchable.meds_prescriptions
      end
    end
    render :index
  end

  private

  def prescription_params
    params.require(:prescription).permit(
      :archived
    )
  end

  def find_by_id
    @prescription = current_user.prescriptions_as_patient.find(params[:id])
  end

  def create_string(prescription)
    data_array = ""
    data_array += "#{prescription.created_at.strftime('%a %d %b %Y')}\n"
    data_array += "Dr #{prescription.professional.last_name}\n"
    data_array += "Patient: #{prescription.patient.first_name} #{prescription.patient.last_name}\n"
    prescription.meds.each do |med|
      data_array += "#{med.name}: "
      med.meds_prescriptions.each do |meds_prescription|
        data_array += "#{meds_prescription.dosage}\n" if prescription.id == meds_prescription.prescription_id
      end
    end
    data_array
  end

  def createqr_code(data_array)
    qrcode = RQRCode::QRCode.new(data_array)
    @svg = qrcode.as_svg(
      color: "000",
      shape_rendering: "crispEdges",
      module_size: 1,
      standalone: true,
      use_path: true
    )
    @svg_big = qrcode.as_svg(
      color: "000",
      shape_rendering: "crispEdges",
      module_size: 4,
      standalone: true,
      use_path: true
    )
  end
end
