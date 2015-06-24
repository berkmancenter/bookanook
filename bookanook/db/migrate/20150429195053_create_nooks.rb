class CreateNooks < ActiveRecord::Migration
  def change
    create_table :nooks do |t|
      t.references :location, index: true, foreign_key: true
      t.string :name
      t.text :description
      t.string :type
      t.text :place
      t.string :photos, array: true, default: []
      t.json :hours

      t.integer :min_capacity
      t.integer :max_capacity

      t.integer :min_schedulable
      t.integer :max_schedulable

      t.integer :min_reservation_length
      t.integer :max_reservation_length

      t.string :amenities, array: true, default: []
      t.json :attrs
      t.json :hidden_attrs

      t.text :use_policy

      t.boolean :bookable
      t.boolean :requires_approval
      t.boolean :repeatable

      t.references :user, index: true, foreign_key: true

      t.timestamps null: false
    end
  end
end
