class AddRefillToMedsPrescriptions < ActiveRecord::Migration[7.0]
  def change
    add_column :meds_prescriptions, :refill, :integer
  end
end
