class AddAircraftIdToFlights < ActiveRecord::Migration[5.1]
  def change
    rename_column :flights, :aircraft_id, :aircraft_identifier
    add_reference :flights, :aircraft, foreign_key: true
  end
end
