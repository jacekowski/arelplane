class CreateSubscriptionPreferences < ActiveRecord::Migration[5.1]
  def change
    create_table :subscription_preferences do |t|
      t.references :user
      t.boolean :new_follower
      t.boolean :no_emails

      t.timestamps
    end
  end
end
