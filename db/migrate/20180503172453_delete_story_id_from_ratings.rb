class DeleteStoryIdFromRatings < ActiveRecord::Migration[5.1]
  def change
    remove_column :ratings, :story_id
    add_column :user_ratings, :story_id, :bigint
    add_index :user_ratings, :story_id
  end
end
