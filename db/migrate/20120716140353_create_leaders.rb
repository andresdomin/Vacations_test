class CreateLeaders < ActiveRecord::Migration
  def change
    create_table :leaders do |t|
      t.string :identification
      t.string :name
      t.string :city
      t.string :email
      t.string :company
      t.string :position
      t.references :leader

      t.timestamps
    end
  end
end
