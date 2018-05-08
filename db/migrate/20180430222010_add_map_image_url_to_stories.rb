class AddMapImageUrlToStories < ActiveRecord::Migration[5.1]
  def change
    add_column :stories, :map_image_url, :string
  end
end
