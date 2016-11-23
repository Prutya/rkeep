class BillsSpendingsRelativeNumbers < ActiveRecord::Migration[5.0]
  def change
    add_column :bills,     :relative_id, :integer
    add_column :spendings, :relative_id, :integer
  end
end
