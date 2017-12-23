require 'test_helper'

class MainsheetsControllerTest < ActionController::TestCase
  setup do
    @mainsheet = mainsheets(:one)
  end

  test "should get index" do
    get :index
    assert_response :success
    assert_not_nil assigns(:mainsheets)
  end

  test "should get new" do
    get :new
    assert_response :success
  end

  test "should create mainsheet" do
    assert_difference('Mainsheet.count') do
      post :create, mainsheet: { created_on: @mainsheet.created_on, description: @mainsheet.description, radiostation_id: @mainsheet.radiostation_id, title: @mainsheet.title, user_id: @mainsheet.user_id }
    end

    assert_redirected_to mainsheet_path(assigns(:mainsheet))
  end

  test "should show mainsheet" do
    get :show, id: @mainsheet
    assert_response :success
  end

  test "should get edit" do
    get :edit, id: @mainsheet
    assert_response :success
  end

  test "should update mainsheet" do
    put :update, id: @mainsheet, mainsheet: { created_on: @mainsheet.created_on, description: @mainsheet.description, radiostation_id: @mainsheet.radiostation_id, title: @mainsheet.title, user_id: @mainsheet.user_id }
    assert_redirected_to mainsheet_path(assigns(:mainsheet))
  end

  test "should destroy mainsheet" do
    assert_difference('Mainsheet.count', -1) do
      delete :destroy, id: @mainsheet
    end

    assert_redirected_to mainsheets_path
  end
end
