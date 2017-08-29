class AddNoOfPeopleToReservation < ActiveRecord::Migration
  def change
    add_column :reservations, :no_of_people, :integer
  end
  def down
    remove_column :reservations, :no_of_people
  end
end
