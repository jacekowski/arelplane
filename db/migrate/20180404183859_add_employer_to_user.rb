class AddEmployerToUser < ActiveRecord::Migration[5.1]
  def change
    add_column :users, :employer, :string
  end
end
