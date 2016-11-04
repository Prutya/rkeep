class CreateGoods < ActiveRecord::Migration[5.0]
  def change
    create_table :goods do |t|
      t.string  :name,  null: false
      t.decimal :price, null: false, default: 0.00, precision: 10, scale: 2

      t.timestamps
    end
  end
end
