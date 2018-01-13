class CreateMapCaches < ActiveRecord::Migration[5.1]
  def change
    add_column :cache_data, :user_id, :integer
  end
end
