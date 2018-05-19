class AddEmailToSubscriptins < ActiveRecord::Migration[5.2]
  def change
    add_column :subscriptions, :email, :boolean
    add_column :subscriptions, :notification, :boolean
  end
end
