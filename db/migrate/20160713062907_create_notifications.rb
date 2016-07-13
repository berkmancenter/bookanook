class CreateNotifications < ActiveRecord::Migration
  def up
    create_table :notifications do |t|
      t.integer :actor_id,    null: false
      t.integer :user_id,     null: false
      t.integer :message_id,  null: false
      t.integer :reservation_id
      t.boolean :seen,        default: false

      t.timestamps null: false
    end
  end

  def down
    drop_table :notifications
  end
end
