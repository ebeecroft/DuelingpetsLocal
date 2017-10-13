require 'test_helper'

class MoviecommentsControllerTest < ActionController::TestCase
  setup do
    @moviecomment = moviecomments(:one)
  end

  test "should get index" do
    get :index
    assert_response :success
    assert_not_nil assigns(:moviecomments)
  end

  test "should get new" do
    get :new
    assert_response :success
  end

  test "should create moviecomment" do
    assert_difference('Moviecomment.count') do
      post :create, moviecomment: { created_on: @moviecomment.created_on, message: @moviecomment.message, movie_id: @moviecomment.movie_id, user_id: @moviecomment.user_id }
    end

    assert_redirected_to moviecomment_path(assigns(:moviecomment))
  end

  test "should show moviecomment" do
    get :show, id: @moviecomment
    assert_response :success
  end

  test "should get edit" do
    get :edit, id: @moviecomment
    assert_response :success
  end

  test "should update moviecomment" do
    put :update, id: @moviecomment, moviecomment: { created_on: @moviecomment.created_on, message: @moviecomment.message, movie_id: @moviecomment.movie_id, user_id: @moviecomment.user_id }
    assert_redirected_to moviecomment_path(assigns(:moviecomment))
  end

  test "should destroy moviecomment" do
    assert_difference('Moviecomment.count', -1) do
      delete :destroy, id: @moviecomment
    end

    assert_redirected_to moviecomments_path
  end
end
