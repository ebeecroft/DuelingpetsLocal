require 'test_helper'

class ForummoderatorsControllerTest < ActionController::TestCase
  setup do
    @forummoderator = forummoderators(:one)
  end

  test "should get index" do
    get :index
    assert_response :success
    assert_not_nil assigns(:forummoderators)
  end

  test "should get new" do
    get :new
    assert_response :success
  end

  test "should create forummoderator" do
    assert_difference('Forummoderator.count') do
      post :create, forummoderator: { created_on: @forummoderator.created_on, forum_id: @forummoderator.forum_id, user_id: @forummoderator.user_id }
    end

    assert_redirected_to forummoderator_path(assigns(:forummoderator))
  end

  test "should show forummoderator" do
    get :show, id: @forummoderator
    assert_response :success
  end

  test "should get edit" do
    get :edit, id: @forummoderator
    assert_response :success
  end

  test "should update forummoderator" do
    put :update, id: @forummoderator, forummoderator: { created_on: @forummoderator.created_on, forum_id: @forummoderator.forum_id, user_id: @forummoderator.user_id }
    assert_redirected_to forummoderator_path(assigns(:forummoderator))
  end

  test "should destroy forummoderator" do
    assert_difference('Forummoderator.count', -1) do
      delete :destroy, id: @forummoderator
    end

    assert_redirected_to forummoderators_path
  end
end
