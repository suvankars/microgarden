class CreateSchedules < ActiveRecord::Migration
  def change
    create_table :schedules do |t|
      t.datetime :start_time
      t.datetime :end_time
      t.boolean :morning_ride, default: false
      t.boolean :evening_ride, default: false
      t.boolean :all_day, default: false
      t.boolean :weekly_ride, default: false
      t.boolean :custom_ride, default: false
      t.boolean :booked, default: false

      t.references :ride, index: true, foreign_key: true

      t.timestamps null: false
    end
  end
end
