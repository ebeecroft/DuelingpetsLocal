require 'test_helper'

class SubsheetsControllerTest < ActionController::TestCase
  setup do
    @subsheet = subsheets(:one)
  end

  test "should get index" do
    get :index
    assert_response :success
    assert_not_nil assigns(:subsheets)
  end

  test "should get new" do
    get :new
    assert_response :success
  end

  test "should create subsheet" do
    assert_difference('Subsheet.count') do
      post :create, subsheet: { bookgroup_id: @subsheet.bookgroup_id, collab_mode: @subsheet.collab_mode, created_on: @subsheet.created_on, description: @subsheet.description, fave_folder: @subsheet.fave_folder, mainsheet_id: @subsheet.mainsheet_id, title: @subsheet.title, user_id: @subsheet.user_id }
    end

    assert_redirected_to subsheet_path(assigns(:subsheet))
  end

  test "should show subsheet" do
    get :show, id: @subsheet
    assert_response :success
  end

  test "should get edit" do
    get :edit, id: @subsheet
    assert_response :success
  end

  test "should update subsheet" do
    put :update, id: @subsheet, subsheet: { bookgroup_id: @subsheet.bookgroup_id, collab_mode: @subsheet.collab_mode, created_on: @subsheet.created_on, description: @subsheet.description, fave_folder: @subsheet.fave_folder, mainsheet_id: @subsheet.mainsheet_id, title: @subsheet.title, user_id: @subsheet.user_id }
    assert_redirected_to subsheet_path(assigns(:subsheet))
  end

  test "should destroy subsheet" do
    assert_difference('Subsheet.count', -1) do
      delete :destroy, id: @subsheet
    end

    assert_redirected_to subsheets_path
  end
end
