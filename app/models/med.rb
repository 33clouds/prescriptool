class Med < ApplicationRecord
  has_many :prescriptions, through: :meds_prescriptions
  has_many :meds_prescriptions
end
