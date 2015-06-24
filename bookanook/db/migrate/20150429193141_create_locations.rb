class CreateLocations < ActiveRecord::Migration
  def change
    create_table :locations do |t|
      t.string :name
      t.text :description

      t.string :amenities, array: true, default: []
      t.json :attrs
      t.json :hidden_attrs
      t.json :hours

      t.timestamps null: false
    end
  end
end
