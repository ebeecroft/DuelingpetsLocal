require 'test_helper'

class MaintopicsubscribersControllerTest < ActionController::TestCase
  setup do
    @maintopicsubscriber = maintopicsubscribers(:one)
  end

  test "should get index" do
    get :index
    assert_response :success
    assert_not_nil assigns(:maintopicsubscribers)
  end

  test "should get new" do
    get :new
    assert_response :success
  end

  test "should create maintopicsubscriber" do
    assert_difference('Maintopicsubscriber.count') do
      post :create, maintopicsubscriber: { created_on: @maintopicsubscriber.created_on, maintopic_id: @maintopicsubscriber.maintopic_id, user_id: @maintopicsubscriber.user_id }
    end

    assert_redirected_to maintopicsubscriber_path(assigns(:maintopicsubscriber))
  end

  test "should show maintopicsubscriber" do
    get :show, id: @maintopicsubscriber
    assert_response :success
  end

  test "should get edit" do
    get :edit, id: @maintopicsubscriber
    assert_response :success
  end

  test "should update maintopicsubscriber" do
    put :update, id: @maintopicsubscriber, maintopicsubscriber: { created_on: @maintopicsubscriber.created_on, maintopic_id: @maintopicsubscriber.maintopic_id, user_id: @maintopicsubscriber.user_id }
    assert_redirected_to maintopicsubscriber_path(assigns(:maintopicsubscriber))
  end

  test "should destroy maintopicsubscriber" do
    assert_difference('Maintopicsubscriber.count', -1) do
      delete :destroy, id: @maintopicsubscriber
    end

    assert_redirected_to maintopicsubscribers_path
  end
end
