require 'test_helper'

class RidersControllerTest < ActionController::TestCase
  setup do
    @rider = riders(:one)
  end

  test "should get index" do
    get :index
    assert_response :success
    assert_not_nil assigns(:riders)
  end

  test "should get new" do
    get :new
    assert_response :success
  end

  test "should create rider" do
    assert_difference('Rider.count') do
      post :create, rider: { address_line2: @rider.address_line2, address_line_1: @rider.address_line_1, age: @rider.age, city: @rider.city, country: @rider.country, email: @rider.email, first_name: @rider.first_name, height: @rider.height, id_proof_documents: @rider.id_proof_documents, last_name: @rider.last_name, market_price: @rider.market_price, number_of_bike: @rider.number_of_bike, office_email: @rider.office_email, parmanent_address: @rider.parmanent_address, phone_number: @rider.phone_number, pincode: @rider.pincode, price_segment: @rider.price_segment, profile_picture: @rider.profile_picture, reference: @rider.reference, reference_email: @rider.reference_email, reference_name: @rider.reference_name, reference_phone_number: @rider.reference_phone_number, state: @rider.state, verification_comment: @rider.verification_comment, verified: @rider.verified, verified_by: @rider.verified_by }
    end

    assert_redirected_to rider_path(assigns(:rider))
  end

  test "should show rider" do
    get :show, id: @rider
    assert_response :success
  end

  test "should get edit" do
    get :edit, id: @rider
    assert_response :success
  end

  test "should update rider" do
    patch :update, id: @rider, rider: { address_line2: @rider.address_line2, address_line_1: @rider.address_line_1, age: @rider.age, city: @rider.city, country: @rider.country, email: @rider.email, first_name: @rider.first_name, height: @rider.height, id_proof_documents: @rider.id_proof_documents, last_name: @rider.last_name, market_price: @rider.market_price, number_of_bike: @rider.number_of_bike, office_email: @rider.office_email, parmanent_address: @rider.parmanent_address, phone_number: @rider.phone_number, pincode: @rider.pincode, price_segment: @rider.price_segment, profile_picture: @rider.profile_picture, reference: @rider.reference, reference_email: @rider.reference_email, reference_name: @rider.reference_name, reference_phone_number: @rider.reference_phone_number, state: @rider.state, verification_comment: @rider.verification_comment, verified: @rider.verified, verified_by: @rider.verified_by }
    assert_redirected_to rider_path(assigns(:rider))
  end

  test "should destroy rider" do
    assert_difference('Rider.count', -1) do
      delete :destroy, id: @rider
    end

    assert_redirected_to riders_path
  end
end
