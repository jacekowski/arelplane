class AddCacheToUsers < ActiveRecord::Migration[5.1]
  def change
    add_column :users, :map_cache, :json
  end
end
