require 'test_helper'

class WatchtypesControllerTest < ActionController::TestCase
  setup do
    @watchtype = watchtypes(:one)
  end

  test "should get index" do
    get :index
    assert_response :success
    assert_not_nil assigns(:watchtypes)
  end

  test "should get new" do
    get :new
    assert_response :success
  end

  test "should create watchtype" do
    assert_difference('Watchtype.count') do
      post :create, watchtype: { amount: @watchtype.amount, created_on: @watchtype.created_on, name: @watchtype.name }
    end

    assert_redirected_to watchtype_path(assigns(:watchtype))
  end

  test "should show watchtype" do
    get :show, id: @watchtype
    assert_response :success
  end

  test "should get edit" do
    get :edit, id: @watchtype
    assert_response :success
  end

  test "should update watchtype" do
    put :update, id: @watchtype, watchtype: { amount: @watchtype.amount, created_on: @watchtype.created_on, name: @watchtype.name }
    assert_redirected_to watchtype_path(assigns(:watchtype))
  end

  test "should destroy watchtype" do
    assert_difference('Watchtype.count', -1) do
      delete :destroy, id: @watchtype
    end

    assert_redirected_to watchtypes_path
  end
end
