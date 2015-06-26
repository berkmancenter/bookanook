class CreateOpenSchedules < ActiveRecord::Migration
  def change
    create_table :open_schedules do |t|
      t.string :name
      t.integer :seconds_per_block, null: false
      t.integer :blocks_per_span
      t.string :span_name
      t.boolean :blocks, array: true, default: []

      t.integer :duration, null: false
      t.datetime :start, null: false

      t.timestamps null: false
    end
  end
end
