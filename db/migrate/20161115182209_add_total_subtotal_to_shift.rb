class AddTotalSubtotalToShift < ActiveRecord::Migration[5.0]
  def change
    add_column :shifts, :total,    :decimal, null: false, default: 0.00, precision: 10, scale: 2
    add_column :shifts, :subtotal, :decimal, null: false, default: 0.00, precision: 10, scale: 2
  end
end
