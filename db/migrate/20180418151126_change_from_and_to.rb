class ChangeFromAndTo < ActiveRecord::Migration[5.1]
  def change
    rename_column :flights, :from_id, :origin_id
    rename_column :flights, :to_id, :destination_id
    change_column :flights, :origin_id, :bigint
    change_column :flights, :destination_id, :bigint
    add_index :flights, :origin_id
    add_index :flights, :destination_id
  end
end
