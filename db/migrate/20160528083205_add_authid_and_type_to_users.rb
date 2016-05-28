class AddAuthidAndTypeToUsers < ActiveRecord::Migration
  def up
    add_column :users, :type, :string
    add_column :users, :authid, :string
  end

  def down
    remove_column :users, :type, :string
    remove_column :users, :authid, :string
  end
end
