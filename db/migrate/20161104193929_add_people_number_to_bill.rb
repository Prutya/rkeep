class AddPeopleNumberToBill < ActiveRecord::Migration[5.0]
  def change
    add_column :bills, :people_number, :integer, null: false, default: 1
  end
end
