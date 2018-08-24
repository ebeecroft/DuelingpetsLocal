require 'test_helper'

class ContainersubscribersControllerTest < ActionController::TestCase
  setup do
    @containersubscriber = containersubscribers(:one)
  end

  test "should get index" do
    get :index
    assert_response :success
    assert_not_nil assigns(:containersubscribers)
  end

  test "should get new" do
    get :new
    assert_response :success
  end

  test "should create containersubscriber" do
    assert_difference('Containersubscriber.count') do
      post :create, containersubscriber: { created_on: @containersubscriber.created_on, topiccontainer_id: @containersubscriber.topiccontainer_id, user_id: @containersubscriber.user_id }
    end

    assert_redirected_to containersubscriber_path(assigns(:containersubscriber))
  end

  test "should show containersubscriber" do
    get :show, id: @containersubscriber
    assert_response :success
  end

  test "should get edit" do
    get :edit, id: @containersubscriber
    assert_response :success
  end

  test "should update containersubscriber" do
    put :update, id: @containersubscriber, containersubscriber: { created_on: @containersubscriber.created_on, topiccontainer_id: @containersubscriber.topiccontainer_id, user_id: @containersubscriber.user_id }
    assert_redirected_to containersubscriber_path(assigns(:containersubscriber))
  end

  test "should destroy containersubscriber" do
    assert_difference('Containersubscriber.count', -1) do
      delete :destroy, id: @containersubscriber
    end

    assert_redirected_to containersubscribers_path
  end
end
