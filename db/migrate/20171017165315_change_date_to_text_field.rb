class ChangeDateToTextField < ActiveRecord::Migration[5.1]
  def change
    change_column :flights, :flight_date, :string
  end
end
