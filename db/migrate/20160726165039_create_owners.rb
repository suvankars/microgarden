class CreateOwners < ActiveRecord::Migration
  def change
    create_table :owners do |t|
      t.string :first_name
      t.string :last_name
      t.string :email
      t.string :phone_number
      t.json :profile_picture, array: true, default: []
      t.string :address_line_1
      t.string :address_line_2
      t.string :city
      t.string :state
      t.string :country
      t.decimal :pincode
      t.text :parmanent_address
      t.string :office_email
      t.json :id_proof_documents, array: true, default: []
      t.decimal :age
      t.string :height
      t.decimal :number_of_bike
      t.string :price_segment
      t.string :market_price
      t.boolean :reference
      t.string :reference_name
      t.string :reference_email
      t.string :reference_phone_number
      t.boolean :verified
      t.text :verification_comment
      t.string :verified_by

      t.timestamps null: false
    end
  end
end
