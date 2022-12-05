class FixColumnName < ActiveRecord::Migration[7.0]
  def change
    rename_column :prescriptions, :professional_id_id, :professional_id
    rename_column :prescriptions, :patient_id_id, :patient_id
  end
end
