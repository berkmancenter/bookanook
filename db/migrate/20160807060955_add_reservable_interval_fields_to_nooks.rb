class AddReservableIntervalFieldsToNooks < ActiveRecord::Migration
  def up
    add_column :nooks, :reservable_before_hours, :integer, default: 2
    add_column :nooks, :unreservable_before_days, :integer, default: 60
  end

  def down
    remove_column :nooks, :reservable_before_hours
    remove_column :nooks, :unreservable_before_days
  end
end
