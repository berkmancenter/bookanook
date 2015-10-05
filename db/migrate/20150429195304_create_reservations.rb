class CreateReservations < ActiveRecord::Migration
  def change
    create_table :reservations do |t|
      t.references :nook, index: true, foreign_key: true
      t.references :user, index: true, foreign_key: true

      t.boolean :public
      t.string :name
      t.string :url
      t.string :stream_url
      t.string :status
      t.integer :priority
      t.datetime :start
      t.datetime :end
      t.text :description
      t.text :notes
      t.string :repeats_every

      t.timestamps null: false
    end
  end
end
