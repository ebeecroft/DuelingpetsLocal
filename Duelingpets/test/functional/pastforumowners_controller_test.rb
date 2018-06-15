require 'test_helper'

class PastforumownersControllerTest < ActionController::TestCase
  setup do
    @pastforumowner = pastforumowners(:one)
  end

  test "should get index" do
    get :index
    assert_response :success
    assert_not_nil assigns(:pastforumowners)
  end

  test "should get new" do
    get :new
    assert_response :success
  end

  test "should create pastforumowner" do
    assert_difference('Pastforumowner.count') do
      post :create, pastforumowner: { created_on: @pastforumowner.created_on, forum_id: @pastforumowner.forum_id, pastowner_id: @pastforumowner.pastowner_id, type: @pastforumowner.type, user_id: @pastforumowner.user_id }
    end

    assert_redirected_to pastforumowner_path(assigns(:pastforumowner))
  end

  test "should show pastforumowner" do
    get :show, id: @pastforumowner
    assert_response :success
  end

  test "should get edit" do
    get :edit, id: @pastforumowner
    assert_response :success
  end

  test "should update pastforumowner" do
    put :update, id: @pastforumowner, pastforumowner: { created_on: @pastforumowner.created_on, forum_id: @pastforumowner.forum_id, pastowner_id: @pastforumowner.pastowner_id, type: @pastforumowner.type, user_id: @pastforumowner.user_id }
    assert_redirected_to pastforumowner_path(assigns(:pastforumowner))
  end

  test "should destroy pastforumowner" do
    assert_difference('Pastforumowner.count', -1) do
      delete :destroy, id: @pastforumowner
    end

    assert_redirected_to pastforumowners_path
  end
end
