class AddDefaultValueToFlightsCount < ActiveRecord::Migration[5.1]
  def up
    change_column :users, :flights_count, :integer, default: 0
  end
  def down
    change_column :users, :flights_count, :integer, default: nil
  end
end
