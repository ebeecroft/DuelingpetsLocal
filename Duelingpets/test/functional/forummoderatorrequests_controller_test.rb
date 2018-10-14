require 'test_helper'

class ForummoderatorrequestsControllerTest < ActionController::TestCase
  setup do
    @forummoderatorrequest = forummoderatorrequests(:one)
  end

  test "should get index" do
    get :index
    assert_response :success
    assert_not_nil assigns(:forummoderatorrequests)
  end

  test "should get new" do
    get :new
    assert_response :success
  end

  test "should create forummoderatorrequest" do
    assert_difference('Forummoderatorrequest.count') do
      post :create, forummoderatorrequest: { created_on: @forummoderatorrequest.created_on, forum_id: @forummoderatorrequest.forum_id, message: @forummoderatorrequest.message, status: @forummoderatorrequest.status, user_id: @forummoderatorrequest.user_id }
    end

    assert_redirected_to forummoderatorrequest_path(assigns(:forummoderatorrequest))
  end

  test "should show forummoderatorrequest" do
    get :show, id: @forummoderatorrequest
    assert_response :success
  end

  test "should get edit" do
    get :edit, id: @forummoderatorrequest
    assert_response :success
  end

  test "should update forummoderatorrequest" do
    put :update, id: @forummoderatorrequest, forummoderatorrequest: { created_on: @forummoderatorrequest.created_on, forum_id: @forummoderatorrequest.forum_id, message: @forummoderatorrequest.message, status: @forummoderatorrequest.status, user_id: @forummoderatorrequest.user_id }
    assert_redirected_to forummoderatorrequest_path(assigns(:forummoderatorrequest))
  end

  test "should destroy forummoderatorrequest" do
    assert_difference('Forummoderatorrequest.count', -1) do
      delete :destroy, id: @forummoderatorrequest
    end

    assert_redirected_to forummoderatorrequests_path
  end
end
