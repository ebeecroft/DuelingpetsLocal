require 'test_helper'

class ForuminvitesControllerTest < ActionController::TestCase
  setup do
    @foruminvite = foruminvites(:one)
  end

  test "should get index" do
    get :index
    assert_response :success
    assert_not_nil assigns(:foruminvites)
  end

  test "should get new" do
    get :new
    assert_response :success
  end

  test "should create foruminvite" do
    assert_difference('Foruminvite.count') do
      post :create, foruminvite: { created_on: @foruminvite.created_on, forum_id: @foruminvite.forum_id, from_user_id: @foruminvite.from_user_id, message: @foruminvite.message, status: @foruminvite.status, user_id: @foruminvite.user_id }
    end

    assert_redirected_to foruminvite_path(assigns(:foruminvite))
  end

  test "should show foruminvite" do
    get :show, id: @foruminvite
    assert_response :success
  end

  test "should get edit" do
    get :edit, id: @foruminvite
    assert_response :success
  end

  test "should update foruminvite" do
    put :update, id: @foruminvite, foruminvite: { created_on: @foruminvite.created_on, forum_id: @foruminvite.forum_id, from_user_id: @foruminvite.from_user_id, message: @foruminvite.message, status: @foruminvite.status, user_id: @foruminvite.user_id }
    assert_redirected_to foruminvite_path(assigns(:foruminvite))
  end

  test "should destroy foruminvite" do
    assert_difference('Foruminvite.count', -1) do
      delete :destroy, id: @foruminvite
    end

    assert_redirected_to foruminvites_path
  end
end
