class RemoveMapCacheFromUser < ActiveRecord::Migration[5.1]
  def change
    remove_column :users, :map_cache, :json
  end
end
