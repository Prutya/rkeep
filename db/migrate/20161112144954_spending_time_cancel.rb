class SpendingTimeCancel < ActiveRecord::Migration[5.0]
  def change
    add_column :spendings, :time_cancel, :datetime
  end
end
