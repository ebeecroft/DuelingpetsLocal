require 'test_helper'

class SubplaylistsControllerTest < ActionController::TestCase
  setup do
    @subplaylist = subplaylists(:one)
  end

  test "should get index" do
    get :index
    assert_response :success
    assert_not_nil assigns(:subplaylists)
  end

  test "should get new" do
    get :new
    assert_response :success
  end

  test "should create subplaylist" do
    assert_difference('Subplaylist.count') do
      post :create, subplaylist: { created_on: @subplaylist.created_on, description: @subplaylist.description, mainplaylist_id: @subplaylist.mainplaylist_id, title: @subplaylist.title, user_id: @subplaylist.user_id }
    end

    assert_redirected_to subplaylist_path(assigns(:subplaylist))
  end

  test "should show subplaylist" do
    get :show, id: @subplaylist
    assert_response :success
  end

  test "should get edit" do
    get :edit, id: @subplaylist
    assert_response :success
  end

  test "should update subplaylist" do
    put :update, id: @subplaylist, subplaylist: { created_on: @subplaylist.created_on, description: @subplaylist.description, mainplaylist_id: @subplaylist.mainplaylist_id, title: @subplaylist.title, user_id: @subplaylist.user_id }
    assert_redirected_to subplaylist_path(assigns(:subplaylist))
  end

  test "should destroy subplaylist" do
    assert_difference('Subplaylist.count', -1) do
      delete :destroy, id: @subplaylist
    end

    assert_redirected_to subplaylists_path
  end
end
