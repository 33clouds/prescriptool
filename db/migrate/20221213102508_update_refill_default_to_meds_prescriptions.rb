class UpdateRefillDefaultToMedsPrescriptions < ActiveRecord::Migration[7.0]
  def change
    change_column_default :meds_prescriptions, :refill, from: nil, to: 0
  end
end
