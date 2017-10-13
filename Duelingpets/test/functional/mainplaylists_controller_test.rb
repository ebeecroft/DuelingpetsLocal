require 'test_helper'

class MainplaylistsControllerTest < ActionController::TestCase
  setup do
    @mainplaylist = mainplaylists(:one)
  end

  test "should get index" do
    get :index
    assert_response :success
    assert_not_nil assigns(:mainplaylists)
  end

  test "should get new" do
    get :new
    assert_response :success
  end

  test "should create mainplaylist" do
    assert_difference('Mainplaylist.count') do
      post :create, mainplaylist: { channel_id: @mainplaylist.channel_id, created_on: @mainplaylist.created_on, description: @mainplaylist.description, title: @mainplaylist.title, user_id: @mainplaylist.user_id }
    end

    assert_redirected_to mainplaylist_path(assigns(:mainplaylist))
  end

  test "should show mainplaylist" do
    get :show, id: @mainplaylist
    assert_response :success
  end

  test "should get edit" do
    get :edit, id: @mainplaylist
    assert_response :success
  end

  test "should update mainplaylist" do
    put :update, id: @mainplaylist, mainplaylist: { channel_id: @mainplaylist.channel_id, created_on: @mainplaylist.created_on, description: @mainplaylist.description, title: @mainplaylist.title, user_id: @mainplaylist.user_id }
    assert_redirected_to mainplaylist_path(assigns(:mainplaylist))
  end

  test "should destroy mainplaylist" do
    assert_difference('Mainplaylist.count', -1) do
      delete :destroy, id: @mainplaylist
    end

    assert_redirected_to mainplaylists_path
  end
end
