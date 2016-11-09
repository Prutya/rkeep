class AddBillItemQuantity < ActiveRecord::Migration[5.0]
  def change
    add_column :bill_items, :quantity, :integer, null: false, default: 1
    remove_reference :bill_items, :user, index: true
    add_reference :bills, :user, index: true
  end
end
