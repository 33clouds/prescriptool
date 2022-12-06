class MedsPrescription < ApplicationRecord
  belongs_to :prescription
  belongs_to :med
end
