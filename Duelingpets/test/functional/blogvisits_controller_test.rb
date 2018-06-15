require 'test_helper'

class BlogvisitsControllerTest < ActionController::TestCase
  setup do
    @blogvisit = blogvisits(:one)
  end

  test "should get index" do
    get :index
    assert_response :success
    assert_not_nil assigns(:blogvisits)
  end

  test "should get new" do
    get :new
    assert_response :success
  end

  test "should create blogvisit" do
    assert_difference('Blogvisit.count') do
      post :create, blogvisit: { created_on: @blogvisit.created_on, from_user_id: @blogvisit.from_user_id, user_id: @blogvisit.user_id }
    end

    assert_redirected_to blogvisit_path(assigns(:blogvisit))
  end

  test "should show blogvisit" do
    get :show, id: @blogvisit
    assert_response :success
  end

  test "should get edit" do
    get :edit, id: @blogvisit
    assert_response :success
  end

  test "should update blogvisit" do
    put :update, id: @blogvisit, blogvisit: { created_on: @blogvisit.created_on, from_user_id: @blogvisit.from_user_id, user_id: @blogvisit.user_id }
    assert_redirected_to blogvisit_path(assigns(:blogvisit))
  end

  test "should destroy blogvisit" do
    assert_difference('Blogvisit.count', -1) do
      delete :destroy, id: @blogvisit
    end

    assert_redirected_to blogvisits_path
  end
end
