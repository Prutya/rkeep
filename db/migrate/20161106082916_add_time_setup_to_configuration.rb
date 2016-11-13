class AddTimeSetupToConfiguration < ActiveRecord::Migration[5.0]
  def change
    add_column :configurations, :time_setup, :datetime, null: false, default: '2016-01-01 10:00:00'

    add_index :configurations, :time_setup, unique: true
  end
end
