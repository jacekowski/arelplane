class AddNumAirportsToUsers < ActiveRecord::Migration[5.1]
  def change
    add_column :users, :num_airports_cache, :integer
    add_column :users, :total_flight_hours_cache, :float
    add_column :users, :num_regions_cache, :integer
  end
end
