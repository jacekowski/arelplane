class CreateCacheData < ActiveRecord::Migration[5.1]
  def change
    create_table :cache_data do |t|
      t.json :map_data

      t.timestamps
    end
  end
end
