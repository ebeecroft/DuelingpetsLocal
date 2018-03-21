require 'test_helper'

class BlacklistednamesControllerTest < ActionController::TestCase
  setup do
    @blacklistedname = blacklistednames(:one)
  end

  test "should get index" do
    get :index
    assert_response :success
    assert_not_nil assigns(:blacklistednames)
  end

  test "should get new" do
    get :new
    assert_response :success
  end

  test "should create blacklistedname" do
    assert_difference('Blacklistedname.count') do
      post :create, blacklistedname: { name: @blacklistedname.name }
    end

    assert_redirected_to blacklistedname_path(assigns(:blacklistedname))
  end

  test "should show blacklistedname" do
    get :show, id: @blacklistedname
    assert_response :success
  end

  test "should get edit" do
    get :edit, id: @blacklistedname
    assert_response :success
  end

  test "should update blacklistedname" do
    put :update, id: @blacklistedname, blacklistedname: { name: @blacklistedname.name }
    assert_redirected_to blacklistedname_path(assigns(:blacklistedname))
  end

  test "should destroy blacklistedname" do
    assert_difference('Blacklistedname.count', -1) do
      delete :destroy, id: @blacklistedname
    end

    assert_redirected_to blacklistednames_path
  end
end
