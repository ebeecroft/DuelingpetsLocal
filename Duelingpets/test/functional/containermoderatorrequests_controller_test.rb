require 'test_helper'

class ContainermoderatorrequestsControllerTest < ActionController::TestCase
  setup do
    @containermoderatorrequest = containermoderatorrequests(:one)
  end

  test "should get index" do
    get :index
    assert_response :success
    assert_not_nil assigns(:containermoderatorrequests)
  end

  test "should get new" do
    get :new
    assert_response :success
  end

  test "should create containermoderatorrequest" do
    assert_difference('Containermoderatorrequest.count') do
      post :create, containermoderatorrequest: { created_on: @containermoderatorrequest.created_on, message: @containermoderatorrequest.message, status: @containermoderatorrequest.status, topiccontainer_id: @containermoderatorrequest.topiccontainer_id, user_id: @containermoderatorrequest.user_id }
    end

    assert_redirected_to containermoderatorrequest_path(assigns(:containermoderatorrequest))
  end

  test "should show containermoderatorrequest" do
    get :show, id: @containermoderatorrequest
    assert_response :success
  end

  test "should get edit" do
    get :edit, id: @containermoderatorrequest
    assert_response :success
  end

  test "should update containermoderatorrequest" do
    put :update, id: @containermoderatorrequest, containermoderatorrequest: { created_on: @containermoderatorrequest.created_on, message: @containermoderatorrequest.message, status: @containermoderatorrequest.status, topiccontainer_id: @containermoderatorrequest.topiccontainer_id, user_id: @containermoderatorrequest.user_id }
    assert_redirected_to containermoderatorrequest_path(assigns(:containermoderatorrequest))
  end

  test "should destroy containermoderatorrequest" do
    assert_difference('Containermoderatorrequest.count', -1) do
      delete :destroy, id: @containermoderatorrequest
    end

    assert_redirected_to containermoderatorrequests_path
  end
end
