class CreateLocations < ActiveRecord::Migration[5.1]
  def change
    create_table :locations do |t|
      t.string :identifier
      t.string :location_type
      t.string :name
      t.string :latitude
      t.string :longitude
      t.integer :elevation
      t.string :continent
      t.string :iso_country
      t.string :iso_region
      t.string :municipality
      t.string :scheduled_service
      t.string :gps_code
      t.string :iata_code
      t.string :local_code
      t.string :home_link
      t.string :wikipedia_link
      t.string :keywords

      t.timestamps
    end
  end
end
