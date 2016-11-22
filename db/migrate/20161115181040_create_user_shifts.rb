class CreateUserShifts < ActiveRecord::Migration[5.0]
  def change
    create_table :user_shifts do |t|
      t.references :user, foreign_key: true
      t.references :shift, foreign_key: true

      t.timestamps
    end

    add_index :user_shifts, [:user_id, :shift_id], unique: true
  end
end
