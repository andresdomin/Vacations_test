class AddDisplayNameToUsers < ActiveRecord::Migration
  def self.up
    add_column :users, :display_name, :string, :default => ""
  end

  def self.down
    remove_column :users, :display_name
  end
  
end
