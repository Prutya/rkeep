class CreateShifts < ActiveRecord::Migration[5.0]
  def change
    create_table :shifts do |t|
      t.datetime :opened_at
      t.datetime :closed_at

      t.timestamps
    end

    add_reference :bills, :shift, foreign_key: true
    add_reference :spendings, :shift, foreign_key: true

    remove_reference :spendings, :user, foreign_key: true
  end
end
