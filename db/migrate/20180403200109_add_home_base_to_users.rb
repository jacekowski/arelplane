class AddHomeBaseToUsers < ActiveRecord::Migration[5.1]
  def change
    add_reference :users, :home_base, references: :locations
  end
end
