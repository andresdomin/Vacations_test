class CreateRequests < ActiveRecord::Migration
  def change
    create_table :requests do |t|
      t.date :begin_at
      t.date :begin_at_approved
      t.date :end_at
      t.date :end_at_approved
      t.integer :days
      t.integer :pay_days
      t.integer :days_approved
      t.integer :pay_days_approved
      t.text :comments
      t.text :comments_approved
      t.string :requester_email
      t.string :approver_email
      t.string :status
      t.datetime :requested_at
      t.datetime :approved_at

      t.timestamps
    end
  end
end
