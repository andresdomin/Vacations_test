class AddReturnDateToRequests < ActiveRecord::Migration
  def change
    add_column :requests, :return_at, :date
  end
end
