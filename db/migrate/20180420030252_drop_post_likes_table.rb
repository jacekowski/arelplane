class DropPostLikesTable < ActiveRecord::Migration[5.1]
  def change
    drop_table :post_likes
  end
end
