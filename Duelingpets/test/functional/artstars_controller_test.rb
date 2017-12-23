require 'test_helper'

class ArtstarsControllerTest < ActionController::TestCase
  setup do
    @artstar = artstars(:one)
  end

  test "should get index" do
    get :index
    assert_response :success
    assert_not_nil assigns(:artstars)
  end

  test "should get new" do
    get :new
    assert_response :success
  end

  test "should create artstar" do
    assert_difference('Artstar.count') do
      post :create, artstar: { art_id: @artstar.art_id, created_on: @artstar.created_on, user_id: @artstar.user_id }
    end

    assert_redirected_to artstar_path(assigns(:artstar))
  end

  test "should show artstar" do
    get :show, id: @artstar
    assert_response :success
  end

  test "should get edit" do
    get :edit, id: @artstar
    assert_response :success
  end

  test "should update artstar" do
    put :update, id: @artstar, artstar: { art_id: @artstar.art_id, created_on: @artstar.created_on, user_id: @artstar.user_id }
    assert_redirected_to artstar_path(assigns(:artstar))
  end

  test "should destroy artstar" do
    assert_difference('Artstar.count', -1) do
      delete :destroy, id: @artstar
    end

    assert_redirected_to artstars_path
  end
end
