class RemoveManagerIdFromNooks < ActiveRecord::Migration
  def up
    remove_foreign_key :nooks, :users
    remove_column :nooks, :user_id
  end

  def down
  	add_column :nooks, :user_id, :integer 
  	add_index :nooks, [ :user_id ], name: 'index_nooks_on_user_id', using: :btree
  	add_foreign_key :nooks, :users 
  end
end
