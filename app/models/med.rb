class Med < ApplicationRecord
  has_many :meds_prescriptions
  has_many :prescriptions, through: :meds_prescriptions
  include PgSearch::Model
  multisearchable against: [:name]
end
