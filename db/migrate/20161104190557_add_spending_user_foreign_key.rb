class AddSpendingUserForeignKey < ActiveRecord::Migration[5.0]
  def change
    add_reference :spendings, :user, foreign_key: true
  end
end
