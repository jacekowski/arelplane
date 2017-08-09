class AddFrequencyKhzToLocations < ActiveRecord::Migration[5.1]
  def change
    add_column :locations, :frequency_khz, :integer
    add_column :locations, :dme_frequency_khz, :integer
    add_column :locations, :dme_channel, :string
    add_column :locations, :dme_latitude_deg, :float
    add_column :locations, :dme_longitude_deg, :float
    add_column :locations, :dme_elevation_ft, :integer
    add_column :locations, :slaved_variation_deg, :float
    add_column :locations, :magnetic_variation_deg, :float
    add_column :locations, :usage_type, :string
    add_column :locations, :power, :string
    add_column :locations, :associated_airport, :string
  end
end
