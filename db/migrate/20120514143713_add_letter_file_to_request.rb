class AddLetterFileToRequest < ActiveRecord::Migration
  def change
    add_column :requests, :letter_file, :string
  end
end
