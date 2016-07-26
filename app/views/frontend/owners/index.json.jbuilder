json.array!(@owners) do |owner|
  json.extract! owner, :id, :first_name, :last_name, :email, :phone_number, :profile_picture, :address_line_1, :address_line_2, :city, :state, :country, :pincode, :parmanent_address, :office_email, :id_proof_documents, :age, :height, :number_of_bike, :price_segment, :market_price, :reference, :reference_name, :reference_email, :reference_phone_number, :verified, :verification_comment, :verified_by
  json.url owner_url(owner, format: :json)
end
