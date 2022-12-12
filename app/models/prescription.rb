class Prescription < ApplicationRecord
  belongs_to :professional, class_name: "User"
  belongs_to :patient, class_name: "User"
  has_many :meds_prescriptions
  has_many :meds, through: :meds_prescriptions
  scope :active, -> { where(archived: false) }
  scope :archived, -> { where(archived: true) }
  # include PgSearch::Model
  # pg_search_scope :search_by_doctor_and_med,
  #   against: [:professional_id],
  #   associated_against: {
  #     user: [:first_name]
  #   },
  #   using: {
  #     tsearch: { prefix: true }
  #   }
end
