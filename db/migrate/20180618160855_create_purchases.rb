class CreatePurchases < ActiveRecord::Migration[5.2]
  def change
    create_table :purchases do |t|
      t.references :user, foreign_key: true
      t.integer :amount
      t.string :object
      t.integer :amount_refunded
      t.string :address_city
      t.string :address_country
      t.string :address_line1
      t.string :address_line2
      t.string :address_state
      t.integer :address_zip
      t.string :brand
      t.string :country
      t.string :description

      t.timestamps
    end
  end
end
