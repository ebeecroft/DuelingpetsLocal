require 'test_helper'

class SubfoldersControllerTest < ActionController::TestCase
  setup do
    @subfolder = subfolders(:one)
  end

  test "should get index" do
    get :index
    assert_response :success
    assert_not_nil assigns(:subfolders)
  end

  test "should get new" do
    get :new
    assert_response :success
  end

  test "should create subfolder" do
    assert_difference('Subfolder.count') do
      post :create, subfolder: { bookgroup_id: @subfolder.bookgroup_id, collab_mode: @subfolder.collab_mode, created_on: @subfolder.created_on, description: @subfolder.description, fave_folder: @subfolder.fave_folder, mainfolder_id: @subfolder.mainfolder_id, title: @subfolder.title, user_id: @subfolder.user_id }
    end

    assert_redirected_to subfolder_path(assigns(:subfolder))
  end

  test "should show subfolder" do
    get :show, id: @subfolder
    assert_response :success
  end

  test "should get edit" do
    get :edit, id: @subfolder
    assert_response :success
  end

  test "should update subfolder" do
    put :update, id: @subfolder, subfolder: { bookgroup_id: @subfolder.bookgroup_id, collab_mode: @subfolder.collab_mode, created_on: @subfolder.created_on, description: @subfolder.description, fave_folder: @subfolder.fave_folder, mainfolder_id: @subfolder.mainfolder_id, title: @subfolder.title, user_id: @subfolder.user_id }
    assert_redirected_to subfolder_path(assigns(:subfolder))
  end

  test "should destroy subfolder" do
    assert_difference('Subfolder.count', -1) do
      delete :destroy, id: @subfolder
    end

    assert_redirected_to subfolders_path
  end
end
