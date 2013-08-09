class CreateVacations < ActiveRecord::Migration
  def change
    create_table :vacations do |t|
      t.string :identification
      t.string :company
      t.string :fullname
      t.date :entry_at
      t.integer :available_days

      t.timestamps
    end
  end
end
