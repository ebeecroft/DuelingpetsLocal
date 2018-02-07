require 'test_helper'

class MemberprivilegesControllerTest < ActionController::TestCase
  setup do
    @memberprivilege = memberprivileges(:one)
  end

  test "should get index" do
    get :index
    assert_response :success
    assert_not_nil assigns(:memberprivileges)
  end

  test "should get new" do
    get :new
    assert_response :success
  end

  test "should create memberprivilege" do
    assert_difference('Memberprivilege.count') do
      post :create, memberprivilege: { created_on: @memberprivilege.created_on, name: @memberprivilege.name }
    end

    assert_redirected_to memberprivilege_path(assigns(:memberprivilege))
  end

  test "should show memberprivilege" do
    get :show, id: @memberprivilege
    assert_response :success
  end

  test "should get edit" do
    get :edit, id: @memberprivilege
    assert_response :success
  end

  test "should update memberprivilege" do
    put :update, id: @memberprivilege, memberprivilege: { created_on: @memberprivilege.created_on, name: @memberprivilege.name }
    assert_redirected_to memberprivilege_path(assigns(:memberprivilege))
  end

  test "should destroy memberprivilege" do
    assert_difference('Memberprivilege.count', -1) do
      delete :destroy, id: @memberprivilege
    end

    assert_redirected_to memberprivileges_path
  end
end
