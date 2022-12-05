class CreatePrescriptions < ActiveRecord::Migration[7.0]
  def change
    create_table :prescriptions do |t|
      t.boolean :archived, default: false
      t.string :qr_code

      t.references :professional_id, foreign_key: { to_table: :users }
      t.references :patient_id, foreign_key: { to_table: :users }

      t.timestamps
    end
  end
end
