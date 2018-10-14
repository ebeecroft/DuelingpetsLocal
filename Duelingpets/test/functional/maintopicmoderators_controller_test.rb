require 'test_helper'

class MaintopicmoderatorsControllerTest < ActionController::TestCase
  setup do
    @maintopicmoderator = maintopicmoderators(:one)
  end

  test "should get index" do
    get :index
    assert_response :success
    assert_not_nil assigns(:maintopicmoderators)
  end

  test "should get new" do
    get :new
    assert_response :success
  end

  test "should create maintopicmoderator" do
    assert_difference('Maintopicmoderator.count') do
      post :create, maintopicmoderator: { created_on: @maintopicmoderator.created_on, maintopic_id: @maintopicmoderator.maintopic_id, user_id: @maintopicmoderator.user_id }
    end

    assert_redirected_to maintopicmoderator_path(assigns(:maintopicmoderator))
  end

  test "should show maintopicmoderator" do
    get :show, id: @maintopicmoderator
    assert_response :success
  end

  test "should get edit" do
    get :edit, id: @maintopicmoderator
    assert_response :success
  end

  test "should update maintopicmoderator" do
    put :update, id: @maintopicmoderator, maintopicmoderator: { created_on: @maintopicmoderator.created_on, maintopic_id: @maintopicmoderator.maintopic_id, user_id: @maintopicmoderator.user_id }
    assert_redirected_to maintopicmoderator_path(assigns(:maintopicmoderator))
  end

  test "should destroy maintopicmoderator" do
    assert_difference('Maintopicmoderator.count', -1) do
      delete :destroy, id: @maintopicmoderator
    end

    assert_redirected_to maintopicmoderators_path
  end
end
