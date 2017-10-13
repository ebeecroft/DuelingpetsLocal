require 'test_helper'

class MoviestarsControllerTest < ActionController::TestCase
  setup do
    @moviestar = moviestars(:one)
  end

  test "should get index" do
    get :index
    assert_response :success
    assert_not_nil assigns(:moviestars)
  end

  test "should get new" do
    get :new
    assert_response :success
  end

  test "should create moviestar" do
    assert_difference('Moviestar.count') do
      post :create, moviestar: { created_on: @moviestar.created_on, movie_id: @moviestar.movie_id, user_id: @moviestar.user_id }
    end

    assert_redirected_to moviestar_path(assigns(:moviestar))
  end

  test "should show moviestar" do
    get :show, id: @moviestar
    assert_response :success
  end

  test "should get edit" do
    get :edit, id: @moviestar
    assert_response :success
  end

  test "should update moviestar" do
    put :update, id: @moviestar, moviestar: { created_on: @moviestar.created_on, movie_id: @moviestar.movie_id, user_id: @moviestar.user_id }
    assert_redirected_to moviestar_path(assigns(:moviestar))
  end

  test "should destroy moviestar" do
    assert_difference('Moviestar.count', -1) do
      delete :destroy, id: @moviestar
    end

    assert_redirected_to moviestars_path
  end
end
