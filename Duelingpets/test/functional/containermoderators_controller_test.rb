require 'test_helper'

class ContainermoderatorsControllerTest < ActionController::TestCase
  setup do
    @containermoderator = containermoderators(:one)
  end

  test "should get index" do
    get :index
    assert_response :success
    assert_not_nil assigns(:containermoderators)
  end

  test "should get new" do
    get :new
    assert_response :success
  end

  test "should create containermoderator" do
    assert_difference('Containermoderator.count') do
      post :create, containermoderator: { created_on: @containermoderator.created_on, topiccontainer_id: @containermoderator.topiccontainer_id, user_id: @containermoderator.user_id }
    end

    assert_redirected_to containermoderator_path(assigns(:containermoderator))
  end

  test "should show containermoderator" do
    get :show, id: @containermoderator
    assert_response :success
  end

  test "should get edit" do
    get :edit, id: @containermoderator
    assert_response :success
  end

  test "should update containermoderator" do
    put :update, id: @containermoderator, containermoderator: { created_on: @containermoderator.created_on, topiccontainer_id: @containermoderator.topiccontainer_id, user_id: @containermoderator.user_id }
    assert_redirected_to containermoderator_path(assigns(:containermoderator))
  end

  test "should destroy containermoderator" do
    assert_difference('Containermoderator.count', -1) do
      delete :destroy, id: @containermoderator
    end

    assert_redirected_to containermoderators_path
  end
end
