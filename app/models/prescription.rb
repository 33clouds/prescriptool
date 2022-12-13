class Prescription < ApplicationRecord
  belongs_to :professional, class_name: "User"
  belongs_to :patient, class_name: "User"
  has_many :meds_prescriptions
  has_many :meds, through: :meds_prescriptions
  scope :active, -> { where(archived: false) }
  scope :archived, -> { where(archived: true) }
end
