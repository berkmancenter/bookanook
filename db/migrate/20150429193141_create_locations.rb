class CreateLocations < ActiveRecord::Migration
  def change
    create_table :locations do |t|
      t.string :name
      t.text :description

      t.references :open_schedule, index: true, foreign_key: true

      t.text :attrs
      t.text :hidden_attrs

      t.timestamps null: false
    end
  end
end
