require 'test_helper'

class BookgroupsControllerTest < ActionController::TestCase
  setup do
    @bookgroup = bookgroups(:one)
  end

  test "should get index" do
    get :index
    assert_response :success
    assert_not_nil assigns(:bookgroups)
  end

  test "should get new" do
    get :new
    assert_response :success
  end

  test "should create bookgroup" do
    assert_difference('Bookgroup.count') do
      post :create, bookgroup: { created_on: @bookgroup.created_on, name: @bookgroup.name }
    end

    assert_redirected_to bookgroup_path(assigns(:bookgroup))
  end

  test "should show bookgroup" do
    get :show, id: @bookgroup
    assert_response :success
  end

  test "should get edit" do
    get :edit, id: @bookgroup
    assert_response :success
  end

  test "should update bookgroup" do
    put :update, id: @bookgroup, bookgroup: { created_on: @bookgroup.created_on, name: @bookgroup.name }
    assert_redirected_to bookgroup_path(assigns(:bookgroup))
  end

  test "should destroy bookgroup" do
    assert_difference('Bookgroup.count', -1) do
      delete :destroy, id: @bookgroup
    end

    assert_redirected_to bookgroups_path
  end
end
