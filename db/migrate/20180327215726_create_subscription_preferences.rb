class CreateSubscriptionPreferences < ActiveRecord::Migration[5.1]
  def change
    create_table :subscription_preferences do |t|
      t.references :user
      t.boolean :new_follower_email, default: true
      t.boolean :no_emails, default: false
      t.string :unsubscribe_hash

      t.timestamps
    end
  end
end
