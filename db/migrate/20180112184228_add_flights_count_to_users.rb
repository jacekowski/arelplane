class AddFlightsCountToUsers < ActiveRecord::Migration[5.1]
  def change
    add_index :users, :flights_count
  end
end
