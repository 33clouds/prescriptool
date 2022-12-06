class Med < ApplicationRecord
  has_many :prescriptions, through: :meds_prescriptions
end
