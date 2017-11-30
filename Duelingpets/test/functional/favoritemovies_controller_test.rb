require 'test_helper'

class FavoritemoviesControllerTest < ActionController::TestCase
  setup do
    @favoritemovie = favoritemovies(:one)
  end

  test "should get index" do
    get :index
    assert_response :success
    assert_not_nil assigns(:favoritemovies)
  end

  test "should get new" do
    get :new
    assert_response :success
  end

  test "should create favoritemovie" do
    assert_difference('Favoritemovie.count') do
      post :create, favoritemovie: { created_on: @favoritemovie.created_on, movie_id: @favoritemovie.movie_id, subplaylist_id: @favoritemovie.subplaylist_id, user_id: @favoritemovie.user_id }
    end

    assert_redirected_to favoritemovie_path(assigns(:favoritemovie))
  end

  test "should show favoritemovie" do
    get :show, id: @favoritemovie
    assert_response :success
  end

  test "should get edit" do
    get :edit, id: @favoritemovie
    assert_response :success
  end

  test "should update favoritemovie" do
    put :update, id: @favoritemovie, favoritemovie: { created_on: @favoritemovie.created_on, movie_id: @favoritemovie.movie_id, subplaylist_id: @favoritemovie.subplaylist_id, user_id: @favoritemovie.user_id }
    assert_redirected_to favoritemovie_path(assigns(:favoritemovie))
  end

  test "should destroy favoritemovie" do
    assert_difference('Favoritemovie.count', -1) do
      delete :destroy, id: @favoritemovie
    end

    assert_redirected_to favoritemovies_path
  end
end
