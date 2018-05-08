class CreateFeedPosts < ActiveRecord::Migration[5.1]
  def change
    create_table :feed_posts do |t|
      t.references :user, foreign_key: true
      t.text :description

      t.timestamps
    end
  end
end
