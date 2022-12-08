class CreateUsersSpecialties < ActiveRecord::Migration[7.0]
  def change
    create_table :users_specialties do |t|
      t.references :specialty, null: false, foreign_key: true
      t.references :user, null: false, foreign_key: true

      t.timestamps
    end
  end
end
