require "rqrcode"
# require "./meds_prescriptions"

class PrescriptionsController < ApplicationController
  before_action :find_by_id, only: [:show, :archive, :qr]

  def index
    @prescriptions = policy_scope(Prescription)
    @prescriptions_pro = current_user.prescriptions_as_professional.active

    if params[:query].present?
      @query = params[:query]
      @results = PgSearch.multisearch(@query)
      if @results.empty?
        @prescriptions = current_user.prescriptions_as_patient.active
        flash[:alert] = "No results found. Please try again."
      end
      @results.each do |result|
        if result.searchable_type == "User"
          if current_user.pro?
            @prescriptions_pro = policy_scope(Prescription).where(patient: result.searchable, professional: current_user)
          else
            @prescriptions = policy_scope(Prescription).where(professional: result.searchable, patient: current_user)
          end
        elsif result.searchable_type == "Med"
          if current_user.pro?
            @prescriptions_pro = result.searchable.prescriptions.where(professional: current_user)
            # raise
          else
            @prescriptions = result.searchable.prescriptions.where(patient: current_user)
          end
        end
      end
    else
      @prescriptions = current_user.prescriptions_as_patient.active
      @prescriptions_pro = current_user.prescriptions_as_professional.active
    end
  end

  def show
    authorize @prescription
    createqr_code(create_string(@prescription))
    # qrcode = RQRCode::QRCode.new("#{request.base_url}/prescriptions/#{@prescription.id}")
  end

  def qr
    authorize @prescription
    createqr_code(create_string(@prescription))
    render plain: @svg_big.html_safe, content_type: 'image/svg+xml'
  end

  def archive
    authorize @prescription
    @prescription.archive
    redirect_to prescriptions_path
  end

  def archived
    @prescriptions = policy_scope(Prescription)
    # @prescriptions = current_user.prescriptions_as_patient.archived
    policy_scope(Prescription)
    current_user.pro ? @prescriptions = current_user.prescriptions_as_professional.archived : @prescriptions = current_user.prescriptions_as_patient.archived
  end

  def new
    @prescription = current_user.prescriptions_as_professional.new
    2.times.each do
      @prescription.meds_prescriptions.build
    end
    authorize @prescription
  end

  def create
    @prescription = current_user.prescriptions_as_professional.new(prescription_params)
    authorize @prescription

    if @prescription.save
      @notification = Notification.create(user: @prescription.patient, message: "You have a new prescription from Dr #{current_user.last_name}")
      redirect_to prescriptions_path
    else
      render :new, status: :unprocessable_entity
    end
  end

  private

  def prescription_params
    params.require(:prescription).permit(
      :patient_id,
      :archived,
      meds_prescriptions_attributes: [
        :med_id,
        :dosage,
        :refill
      ]
    )
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
