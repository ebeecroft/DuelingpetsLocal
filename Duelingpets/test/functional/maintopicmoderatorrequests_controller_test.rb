require 'test_helper'

class MaintopicmoderatorrequestsControllerTest < ActionController::TestCase
  setup do
    @maintopicmoderatorrequest = maintopicmoderatorrequests(:one)
  end

  test "should get index" do
    get :index
    assert_response :success
    assert_not_nil assigns(:maintopicmoderatorrequests)
  end

  test "should get new" do
    get :new
    assert_response :success
  end

  test "should create maintopicmoderatorrequest" do
    assert_difference('Maintopicmoderatorrequest.count') do
      post :create, maintopicmoderatorrequest: { created_on: @maintopicmoderatorrequest.created_on, maintopic_id: @maintopicmoderatorrequest.maintopic_id, message: @maintopicmoderatorrequest.message, status: @maintopicmoderatorrequest.status, user_id: @maintopicmoderatorrequest.user_id }
    end

    assert_redirected_to maintopicmoderatorrequest_path(assigns(:maintopicmoderatorrequest))
  end

  test "should show maintopicmoderatorrequest" do
    get :show, id: @maintopicmoderatorrequest
    assert_response :success
  end

  test "should get edit" do
    get :edit, id: @maintopicmoderatorrequest
    assert_response :success
  end

  test "should update maintopicmoderatorrequest" do
    put :update, id: @maintopicmoderatorrequest, maintopicmoderatorrequest: { created_on: @maintopicmoderatorrequest.created_on, maintopic_id: @maintopicmoderatorrequest.maintopic_id, message: @maintopicmoderatorrequest.message, status: @maintopicmoderatorrequest.status, user_id: @maintopicmoderatorrequest.user_id }
    assert_redirected_to maintopicmoderatorrequest_path(assigns(:maintopicmoderatorrequest))
  end

  test "should destroy maintopicmoderatorrequest" do
    assert_difference('Maintopicmoderatorrequest.count', -1) do
      delete :destroy, id: @maintopicmoderatorrequest
    end

    assert_redirected_to maintopicmoderatorrequests_path
  end
end
