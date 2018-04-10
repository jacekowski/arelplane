class ChangeColumnType < ActiveRecord::Migration[5.1]
  def change
    change_column :flights, :total_time, :decimal, precision: 10, scale: 2
  end
end
