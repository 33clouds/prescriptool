class AddDefaultFalseToUsersPro < ActiveRecord::Migration[7.0]
  def change
    change_column_default :users, :pro, false
  end
end
