class RenameStartAndEndFieldsInReservations < ActiveRecord::Migration
  def up
    rename_column :reservations, :start, :start_time
    rename_column :reservations, :end, :end_time
  end

  def down
    rename_column :reservations, :start_time, :start
    rename_column :reservations, :end_time, :end
  end
end
