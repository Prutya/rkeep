class CreateSpendings < ActiveRecord::Migration[5.0]
  def change
    create_table :spendings do |t|
      t.string  :name,  null: false
      t.decimal :total, null: false, default: 0.00, precision: 10, scale: 2

      t.timestamps
    end
  end
end
