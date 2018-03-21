require 'test_helper'

class FriendrequestsControllerTest < ActionController::TestCase
  setup do
    @friendrequest = friendrequests(:one)
  end

  test "should get index" do
    get :index
    assert_response :success
    assert_not_nil assigns(:friendrequests)
  end

  test "should get new" do
    get :new
    assert_response :success
  end

  test "should create friendrequest" do
    assert_difference('Friendrequest.count') do
      post :create, friendrequest: { created_on: @friendrequest.created_on, from_user_id: @friendrequest.from_user_id, message: @friendrequest.message, status: @friendrequest.status, user_id: @friendrequest.user_id }
    end

    assert_redirected_to friendrequest_path(assigns(:friendrequest))
  end

  test "should show friendrequest" do
    get :show, id: @friendrequest
    assert_response :success
  end

  test "should get edit" do
    get :edit, id: @friendrequest
    assert_response :success
  end

  test "should update friendrequest" do
    put :update, id: @friendrequest, friendrequest: { created_on: @friendrequest.created_on, from_user_id: @friendrequest.from_user_id, message: @friendrequest.message, status: @friendrequest.status, user_id: @friendrequest.user_id }
    assert_redirected_to friendrequest_path(assigns(:friendrequest))
  end

  test "should destroy friendrequest" do
    assert_difference('Friendrequest.count', -1) do
      delete :destroy, id: @friendrequest
    end

    assert_redirected_to friendrequests_path
  end
end
