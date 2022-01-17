class CreateProducts < ActiveRecord::Migration[6.1]
  def change
    create_table :products do |t|
      t.string :amount_available
      t.integer :cost
      t.string :product_name
      t.references :seller, foreign_key: { to_table: :users }, index: true, null: false

      t.timestamps
    end
  end
end
