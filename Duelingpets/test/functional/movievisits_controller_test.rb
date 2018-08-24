require 'test_helper'

class MovievisitsControllerTest < ActionController::TestCase
  setup do
    @movievisit = movievisits(:one)
  end

  test "should get index" do
    get :index
    assert_response :success
    assert_not_nil assigns(:movievisits)
  end

  test "should get new" do
    get :new
    assert_response :success
  end

  test "should create movievisit" do
    assert_difference('Movievisit.count') do
      post :create, movievisit: { created_on: @movievisit.created_on, movie_id: @movievisit.movie_id, user_id: @movievisit.user_id }
    end

    assert_redirected_to movievisit_path(assigns(:movievisit))
  end

  test "should show movievisit" do
    get :show, id: @movievisit
    assert_response :success
  end

  test "should get edit" do
    get :edit, id: @movievisit
    assert_response :success
  end

  test "should update movievisit" do
    put :update, id: @movievisit, movievisit: { created_on: @movievisit.created_on, movie_id: @movievisit.movie_id, user_id: @movievisit.user_id }
    assert_redirected_to movievisit_path(assigns(:movievisit))
  end

  test "should destroy movievisit" do
    assert_difference('Movievisit.count', -1) do
      delete :destroy, id: @movievisit
    end

    assert_redirected_to movievisits_path
  end
end
