require 'test_helper'

class SubtopicsubscribersControllerTest < ActionController::TestCase
  setup do
    @subtopicsubscriber = subtopicsubscribers(:one)
  end

  test "should get index" do
    get :index
    assert_response :success
    assert_not_nil assigns(:subtopicsubscribers)
  end

  test "should get new" do
    get :new
    assert_response :success
  end

  test "should create subtopicsubscriber" do
    assert_difference('Subtopicsubscriber.count') do
      post :create, subtopicsubscriber: { created_on: @subtopicsubscriber.created_on, subtopic_id: @subtopicsubscriber.subtopic_id, user_id: @subtopicsubscriber.user_id }
    end

    assert_redirected_to subtopicsubscriber_path(assigns(:subtopicsubscriber))
  end

  test "should show subtopicsubscriber" do
    get :show, id: @subtopicsubscriber
    assert_response :success
  end

  test "should get edit" do
    get :edit, id: @subtopicsubscriber
    assert_response :success
  end

  test "should update subtopicsubscriber" do
    put :update, id: @subtopicsubscriber, subtopicsubscriber: { created_on: @subtopicsubscriber.created_on, subtopic_id: @subtopicsubscriber.subtopic_id, user_id: @subtopicsubscriber.user_id }
    assert_redirected_to subtopicsubscriber_path(assigns(:subtopicsubscriber))
  end

  test "should destroy subtopicsubscriber" do
    assert_difference('Subtopicsubscriber.count', -1) do
      delete :destroy, id: @subtopicsubscriber
    end

    assert_redirected_to subtopicsubscribers_path
  end
end
