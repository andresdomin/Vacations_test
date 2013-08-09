class AddIdentificationToUsers < ActiveRecord::Migration
 def self.up
    add_column :users, :identification, :string, :default => ""
  end

  def self.down
    remove_column :users, :identification
  end
end
