class RemoveShiftBillNullConstraints < ActiveRecord::Migration[5.0]
  def change
    change_column :bills, :total,    :decimal, precision: 10, scale: 2, null: true, default: nil
    change_column :bills, :subtotal, :decimal, precision: 10, scale: 2, null: true, default: nil

    change_column :shifts, :total,           :decimal, precision: 10, scale: 2, null: true, default: nil
    change_column :shifts, :total_revenue,   :decimal, precision: 10, scale: 2, null: true, default: nil
    change_column :shifts, :total_spendings, :decimal, precision: 10, scale: 2, null: true, default: nil
  end
end
