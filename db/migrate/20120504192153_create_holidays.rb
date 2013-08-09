class CreateHolidays < ActiveRecord::Migration
  def change
    create_table :holidays do |t|
      t.date :holiday_at
      t.string :country

      t.timestamps
    end
  end
end
