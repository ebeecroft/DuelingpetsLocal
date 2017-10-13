require 'test_helper'

class DonationboxesControllerTest < ActionController::TestCase
  setup do
    @donationbox = donationboxes(:one)
  end

  test "should get index" do
    get :index
    assert_response :success
    assert_not_nil assigns(:donationboxes)
  end

  test "should get new" do
    get :new
    assert_response :success
  end

  test "should create donationbox" do
    assert_difference('Donationbox.count') do
      post :create, donationbox: { created_on: @donationbox.created_on, currentPoints: @donationbox.currentPoints, description: @donationbox.description, hitgoal: @donationbox.hitgoal, goalPoints: @donationbox.goalPoints, openbox: @donationbox.openbox, user_id: @donationbox.user_id }
    end

    assert_redirected_to donationbox_path(assigns(:donationbox))
  end

  test "should show donationbox" do
    get :show, id: @donationbox
    assert_response :success
  end

  test "should get edit" do
    get :edit, id: @donationbox
    assert_response :success
  end

  test "should update donationbox" do
    put :update, id: @donationbox, donationbox: { created_on: @donationbox.created_on, currentPoints: @donationbox.currentPoints, description: @donationbox.description, hitgoal: @donationbox.hitgoal, goalPoints: @donationbox.goalPoints, openbox: @donationbox.openbox, user_id: @donationbox.user_id }
    assert_redirected_to donationbox_path(assigns(:donationbox))
  end

  test "should destroy donationbox" do
    assert_difference('Donationbox.count', -1) do
      delete :destroy, id: @donationbox
    end

    assert_redirected_to donationboxes_path
  end
end
