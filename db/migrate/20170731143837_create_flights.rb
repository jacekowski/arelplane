class CreateFlights < ActiveRecord::Migration[5.1]
  def change
    create_table :flights do |t|
      t.datetime :flight_date
      t.string :aircraft_id
      t.integer :from_id
      t.integer :to_id
      t.string :time_out
      t.string :time_in
      t.float :total_time
      t.float :pic
      t.float :distance

      t.timestamps
    end
  end
end
