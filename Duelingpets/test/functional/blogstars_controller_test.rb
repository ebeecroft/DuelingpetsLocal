require 'test_helper'

class BlogstarsControllerTest < ActionController::TestCase
  setup do
    @blogstar = blogstars(:one)
  end

  test "should get index" do
    get :index
    assert_response :success
    assert_not_nil assigns(:blogstars)
  end

  test "should get new" do
    get :new
    assert_response :success
  end

  test "should create blogstar" do
    assert_difference('Blogstar.count') do
      post :create, blogstar: { blog_id: @blogstar.blog_id, created_on: @blogstar.created_on, user_id: @blogstar.user_id }
    end

    assert_redirected_to blogstar_path(assigns(:blogstar))
  end

  test "should show blogstar" do
    get :show, id: @blogstar
    assert_response :success
  end

  test "should get edit" do
    get :edit, id: @blogstar
    assert_response :success
  end

  test "should update blogstar" do
    put :update, id: @blogstar, blogstar: { blog_id: @blogstar.blog_id, created_on: @blogstar.created_on, user_id: @blogstar.user_id }
    assert_redirected_to blogstar_path(assigns(:blogstar))
  end

  test "should destroy blogstar" do
    assert_difference('Blogstar.count', -1) do
      delete :destroy, id: @blogstar
    end

    assert_redirected_to blogstars_path
  end
end
