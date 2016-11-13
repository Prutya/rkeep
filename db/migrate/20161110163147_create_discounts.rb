class CreateDiscounts < ActiveRecord::Migration[5.0]
  def change
    create_table :discounts do |t|
      t.decimal :value, null: false, default: 0.00, precision: 5, scale: 2

      t.timestamps

      t.index :value, unique: true
    end

    remove_column :bills, :discount, :decimal, null: false, default: 0.00, precision: 5, scale: 2

    add_reference :bills, :discount, foreign_key: true
  end
end
