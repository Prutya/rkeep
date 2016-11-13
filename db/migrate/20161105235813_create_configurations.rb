class CreateConfigurations < ActiveRecord::Migration[5.0]
  def change
    create_table :configurations do |t|
      t.string   :company_name
      t.datetime :time_opens, null: false, default: '2016-01-01 10:00:00'

      t.timestamps
    end
  end
end
