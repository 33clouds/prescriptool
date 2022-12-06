class CreateMedsPrescriptions < ActiveRecord::Migration[7.0]
  def change
    create_table :meds_prescriptions do |t|
      t.string :dosage
      t.references :prescription, foreign_key: true, null: false
      t.references :med, foreign_key: true, null: false
      t.timestamps
    end
  end
end
