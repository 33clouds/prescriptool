require "rqrcode"

class PrescriptionsController < ApplicationController
  before_action :find_by_id, only: [:show, :archive]

  def index
    @prescriptions = policy_scope(Prescription)
    @prescriptions_pro = current_user.prescriptions_as_professional.active
    
    if params[:query].present?
      @query = params[:query]
      @results = PgSearch.multisearch(@query)
      @prescriptions = []
      if @results.empty?
        @prescriptions = current_user.prescriptions_as_patient.active
        flash[:alert] = "No results found. Please try again."
      end
      @results.each do |result|
        if result.searchable_type == "User"
          tmp = Prescription.where(professional: result.searchable, patient: current_user)
          tmp.each do |prescription|
            @prescriptions << prescription
          end
        else
          result.searchable.meds_prescriptions.each do |meds_prescription|
            @prescriptions << meds_prescription.prescription if meds_prescription.prescription.patient == current_user
          end
        end
      end
    else
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
    # @prescriptions = current_user.prescriptions_as_patient.archived
    policy_scope(Prescription)
    current_user.pro ? @prescriptions = current_user.prescriptions_as_professional.archived : @prescriptions = current_user.prescriptions_as_patient.archived
  end

  def new
    @prescription = Prescription.new
    @prescription.professional = current_user
    @prescription.meds_prescriptions.build
    @meds_prescription = MedsPrescription.new
    # @prescription = current_user.prescriptions_as_professional.new
    authorize @prescription
  end

  def create
    @prescription = Prescription.new(prescription_params)
    @prescription.professional = current_user
    @meds_prescription = MedsPrescription.new
    authorize @prescription

    if @prescription.save
      @md = MedsPrescription.new
      @md.dosage = params[:prescription][:meds_prescription][:dosage]
      @md.med = Med.find params[:prescription][:meds_prescription][:med_id]
      @md.prescription = @prescription
      @md.save
      redirect_to prescriptions_path
    else
      render :new, status: :unprocessable_entity
    end
  end

  private

  def prescription_params
    params.require(:prescription).permit(:patient_id, :archived)
  end

  def find_by_id
    # @prescription = current_user.prescriptions_as_patient.find(params[:id])
    current_user.pro ? @prescription = current_user.prescriptions_as_professional.find(params[:id]) : @prescription = current_user.prescriptions_as_patient.find(params[:id])
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
