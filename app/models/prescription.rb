class Prescription < ApplicationRecord
  DOSAGE = ["one pill every morning for one month", "two pills during lunch for two weeks", "one pill before sleeping during six months", "one pill two hours before eating for one week"]
  belongs_to :professional, class_name: "User"
  belongs_to :patient, class_name: "User"

  has_many :meds_prescriptions
  has_many :meds, through: :meds_prescriptions

  scope :active, -> { where(archived: false) }
  scope :archived, -> { where(archived: true) }

  accepts_nested_attributes_for :meds_prescriptions
end
