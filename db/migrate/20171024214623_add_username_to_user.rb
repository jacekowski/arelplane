class AddUsernameToUser < ActiveRecord::Migration[5.1]
  def change
    add_column :users, :username, :string
    add_index :users, :username
    add_index :users, :name
  end
end
