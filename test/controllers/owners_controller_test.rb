require 'test_helper'

class OwnersControllerTest < ActionController::TestCase
  setup do
    @owner = owners(:one)
  end

  test "should get index" do
    get :index
    assert_response :success
    assert_not_nil assigns(:owners)
  end

  test "should get new" do
    get :new
    assert_response :success
  end

  test "should create owner" do
    assert_difference('Owner.count') do
      post :create, owner: { address_line_1: @owner.address_line_1, address_line_2: @owner.address_line_2, age: @owner.age, city: @owner.city, country: @owner.country, email: @owner.email, first_name: @owner.first_name, height: @owner.height, id_proof_documents: @owner.id_proof_documents, last_name: @owner.last_name, market_price: @owner.market_price, number_of_bike: @owner.number_of_bike, office_email: @owner.office_email, parmanent_address: @owner.parmanent_address, phone_number: @owner.phone_number, pincode: @owner.pincode, price_segment: @owner.price_segment, profile_picture: @owner.profile_picture, reference: @owner.reference, reference_email: @owner.reference_email, reference_name: @owner.reference_name, reference_phone_number: @owner.reference_phone_number, state: @owner.state, verification_comment: @owner.verification_comment, verified: @owner.verified, verified_by: @owner.verified_by }
    end

    assert_redirected_to owner_path(assigns(:owner))
  end

  test "should show owner" do
    get :show, id: @owner
    assert_response :success
  end

  test "should get edit" do
    get :edit, id: @owner
    assert_response :success
  end

  test "should update owner" do
    patch :update, id: @owner, owner: { address_line_1: @owner.address_line_1, address_line_2: @owner.address_line_2, age: @owner.age, city: @owner.city, country: @owner.country, email: @owner.email, first_name: @owner.first_name, height: @owner.height, id_proof_documents: @owner.id_proof_documents, last_name: @owner.last_name, market_price: @owner.market_price, number_of_bike: @owner.number_of_bike, office_email: @owner.office_email, parmanent_address: @owner.parmanent_address, phone_number: @owner.phone_number, pincode: @owner.pincode, price_segment: @owner.price_segment, profile_picture: @owner.profile_picture, reference: @owner.reference, reference_email: @owner.reference_email, reference_name: @owner.reference_name, reference_phone_number: @owner.reference_phone_number, state: @owner.state, verification_comment: @owner.verification_comment, verified: @owner.verified, verified_by: @owner.verified_by }
    assert_redirected_to owner_path(assigns(:owner))
  end

  test "should destroy owner" do
    assert_difference('Owner.count', -1) do
      delete :destroy, id: @owner
    end

    assert_redirected_to owners_path
  end
end
