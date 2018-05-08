class ChangeFeedPostToStory < ActiveRecord::Migration[5.1]
  def change
    rename_table :feed_posts, :stories
    rename_column :flights, :feed_post_id, :story_id
    rename_column :ratings, :feed_post_id, :story_id
  end
end
