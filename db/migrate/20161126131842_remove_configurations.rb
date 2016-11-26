class RemoveConfigurations < ActiveRecord::Migration[5.0]
  def change
    drop_table :configurations do |t|
      t.string   :company_name
      t.datetime :time_opens,   default: '2016-01-01 10:00:00', null: false
      t.datetime :time_setup,   default: '2016-01-01 10:00:00', null: false

      t.timestamps

      t.index :time_setup, unique: true
    end
  end
end
