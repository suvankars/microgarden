class CreateNotifications < ActiveRecord::Migration
  def change
    create_table :notifications do |t|
      t.string :name
      t.string :email
      t.string :phone
      t.string :pincode
      t.text :message

      t.timestamps null: false
    end
  end
end
