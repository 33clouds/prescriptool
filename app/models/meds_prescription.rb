class MedsPrescription < ApplicationRecord
  belongs_to :prescription
  belongs_to :med

  # def update_refill
  #   @meds_prescription.refill -= 1
  #   if @meds_prescription.refill.zero?
  #     redirect_to archived_prescriptions_path, notice: "Prescription scanned!: no more available"
  #   else
  #     redirect_to prescriptions_path, notice: "Prescription scanned!: still available"
  #   end
  # end
end
