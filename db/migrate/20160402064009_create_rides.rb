class CreateRides < ActiveRecord::Migration
  def change
    create_table :rides do |t|
      t.string :title
      t.text :description
      t.string :rider_height
      t.string :frame_size
      t.string :additional_offerings
      t.decimal :number_of_bikes
      t.decimal :hourly_rental
      t.decimal :morning_rental
      t.decimal :evening_rental
      t.decimal :daily_rental
      t.decimal :weekly_rental
      t.string :address
      t.float :latitude
      t.float :longitude
      t.string :street
      t.string :city
      t.string :state
      t.string :country
      t.integer :pincode
      t.string :landmark
      t.boolean :willing_to_deliver

      t.string :make
      t.string :model
      t.string :purchase_year
      t.integer :market_price
      t.string :extras


      t.timestamps null: false
    end
  end
end