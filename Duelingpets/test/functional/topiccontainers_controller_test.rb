require 'test_helper'

class TopiccontainersControllerTest < ActionController::TestCase
  setup do
    @topiccontainer = topiccontainers(:one)
  end

  test "should get index" do
    get :index
    assert_response :success
    assert_not_nil assigns(:topiccontainers)
  end

  test "should get new" do
    get :new
    assert_response :success
  end

  test "should create topiccontainer" do
    assert_difference('Topiccontainer.count') do
      post :create, topiccontainer: { created_on: @topiccontainer.created_on, description: @topiccontainer.description, forum_id: @topiccontainer.forum_id, title: @topiccontainer.title, user_id: @topiccontainer.user_id }
    end

    assert_redirected_to topiccontainer_path(assigns(:topiccontainer))
  end

  test "should show topiccontainer" do
    get :show, id: @topiccontainer
    assert_response :success
  end

  test "should get edit" do
    get :edit, id: @topiccontainer
    assert_response :success
  end

  test "should update topiccontainer" do
    put :update, id: @topiccontainer, topiccontainer: { created_on: @topiccontainer.created_on, description: @topiccontainer.description, forum_id: @topiccontainer.forum_id, title: @topiccontainer.title, user_id: @topiccontainer.user_id }
    assert_redirected_to topiccontainer_path(assigns(:topiccontainer))
  end

  test "should destroy topiccontainer" do
    assert_difference('Topiccontainer.count', -1) do
      delete :destroy, id: @topiccontainer
    end

    assert_redirected_to topiccontainers_path
  end
end
