class CreateFlightWaypoints < ActiveRecord::Migration[5.1]
  def change
    create_table :flight_waypoints do |t|
      t.integer :location_id
      t.integer :flight_id

      t.timestamps
    end
  end
end
