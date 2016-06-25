class AddModifiableBeforeToNooks < ActiveRecord::Migration
  def up
    add_column :nooks, :modifiable_before, :Integer, default: 48
  end
	
  def down
    remove_column :nooks, :modifiable_before, :Integer
  end
end
