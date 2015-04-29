class CreateLocations < ActiveRecord::Migration
  def change
    create_table :locations do |t|
      t.string :name
      t.text :amenities
      t.text :attrs
      t.text :hidden_attrs
      t.text :hours
      t.text :description

      t.timestamps null: false
    end
  end
end
