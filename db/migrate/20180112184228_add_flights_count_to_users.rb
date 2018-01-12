class AddFlightsCountToUsers < ActiveRecord::Migration[5.1]
  def change
    add_column :users, :flights_count, :integer
    add_index :users, :flights_count
  end
end
