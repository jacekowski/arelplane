class AddStoriesTosubscriptionPreferences < ActiveRecord::Migration[5.2]
  def change
    add_column :subscription_preferences, :story_emails, :boolean, default: true
  end
end
