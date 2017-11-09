class CreateUserFollowings < ActiveRecord::Migration[5.1]
  def change
    create_table :user_followings do |t|
      t.integer :follower_id
      t.integer :following_id

      t.timestamps
    end
  end
end
