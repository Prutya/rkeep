class CreateBillItems < ActiveRecord::Migration[5.0]
  def change
    create_table :bill_items do |t|
      t.references :user, foreign_key: true
      t.references :bill, foreign_key: true
      t.references :good, foreign_key: true
      t.datetime :time_cancel

      t.timestamps
    end
  end
end
