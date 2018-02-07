require 'test_helper'

class ForumtypesControllerTest < ActionController::TestCase
  setup do
    @forumtype = forumtypes(:one)
  end

  test "should get index" do
    get :index
    assert_response :success
    assert_not_nil assigns(:forumtypes)
  end

  test "should get new" do
    get :new
    assert_response :success
  end

  test "should create forumtype" do
    assert_difference('Forumtype.count') do
      post :create, forumtype: { created_on: @forumtype.created_on, name: @forumtype.name }
    end

    assert_redirected_to forumtype_path(assigns(:forumtype))
  end

  test "should show forumtype" do
    get :show, id: @forumtype
    assert_response :success
  end

  test "should get edit" do
    get :edit, id: @forumtype
    assert_response :success
  end

  test "should update forumtype" do
    put :update, id: @forumtype, forumtype: { created_on: @forumtype.created_on, name: @forumtype.name }
    assert_redirected_to forumtype_path(assigns(:forumtype))
  end

  test "should destroy forumtype" do
    assert_difference('Forumtype.count', -1) do
      delete :destroy, id: @forumtype
    end

    assert_redirected_to forumtypes_path
  end
end
