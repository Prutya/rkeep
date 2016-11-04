class CreateBills < ActiveRecord::Migration[5.0]
  def change
    create_table :bills do |t|
      t.references :table,       foreign_key: true
      t.decimal    :total,       null: false, default: 0.00, precision: 10, scale: 2
      t.decimal    :subtotal,    null: false, default: 0.00, precision: 10, scale: 2
      t.decimal    :discount,    null: false, default: 0.00, precision:  5, scale: 2
      t.datetime   :time_cancel
      t.datetime   :time_close

      t.timestamps
    end
  end
end
