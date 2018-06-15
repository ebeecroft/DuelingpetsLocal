require 'test_helper'

class UservisitsControllerTest < ActionController::TestCase
  setup do
    @uservisit = uservisits(:one)
  end

  test "should get index" do
    get :index
    assert_response :success
    assert_not_nil assigns(:uservisits)
  end

  test "should get new" do
    get :new
    assert_response :success
  end

  test "should create uservisit" do
    assert_difference('Uservisit.count') do
      post :create, uservisit: { created_on: @uservisit.created_on, from_user_id: @uservisit.from_user_id, user_id: @uservisit.user_id }
    end

    assert_redirected_to uservisit_path(assigns(:uservisit))
  end

  test "should show uservisit" do
    get :show, id: @uservisit
    assert_response :success
  end

  test "should get edit" do
    get :edit, id: @uservisit
    assert_response :success
  end

  test "should update uservisit" do
    put :update, id: @uservisit, uservisit: { created_on: @uservisit.created_on, from_user_id: @uservisit.from_user_id, user_id: @uservisit.user_id }
    assert_redirected_to uservisit_path(assigns(:uservisit))
  end

  test "should destroy uservisit" do
    assert_difference('Uservisit.count', -1) do
      delete :destroy, id: @uservisit
    end

    assert_redirected_to uservisits_path
  end
end
