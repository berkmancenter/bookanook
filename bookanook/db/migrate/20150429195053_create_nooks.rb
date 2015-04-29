class CreateNooks < ActiveRecord::Migration
  def change
    create_table :nooks do |t|
      t.references :location, index: true, foreign_key: true
      t.string :name
      t.string :type
      t.integer :min_capacity
      t.integer :max_capacity
      t.text :amenities
      t.text :attrs
      t.text :hidden_attrs
      t.text :hours
      t.text :use_policy
      t.text :description
      t.text :photos
      t.integer :min_schedulable
      t.integer :max_schedulable
      t.boolean :bookable
      t.integer :min_reservation_length
      t.integer :max_reservation_length
      t.boolean :requires_approval
      t.boolean :repeatable
      t.references :manager, index: true, foreign_key: true
      t.text :location

      t.timestamps null: false
    end
  end
end
