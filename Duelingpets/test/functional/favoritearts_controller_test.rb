require 'test_helper'

class FavoriteartsControllerTest < ActionController::TestCase
  setup do
    @favoriteart = favoritearts(:one)
  end

  test "should get index" do
    get :index
    assert_response :success
    assert_not_nil assigns(:favoritearts)
  end

  test "should get new" do
    get :new
    assert_response :success
  end

  test "should create favoriteart" do
    assert_difference('Favoriteart.count') do
      post :create, favoriteart: { art_id: @favoriteart.art_id, created_on: @favoriteart.created_on, subfolder_id: @favoriteart.subfolder_id, user_id: @favoriteart.user_id }
    end

    assert_redirected_to favoriteart_path(assigns(:favoriteart))
  end

  test "should show favoriteart" do
    get :show, id: @favoriteart
    assert_response :success
  end

  test "should get edit" do
    get :edit, id: @favoriteart
    assert_response :success
  end

  test "should update favoriteart" do
    put :update, id: @favoriteart, favoriteart: { art_id: @favoriteart.art_id, created_on: @favoriteart.created_on, subfolder_id: @favoriteart.subfolder_id, user_id: @favoriteart.user_id }
    assert_redirected_to favoriteart_path(assigns(:favoriteart))
  end

  test "should destroy favoriteart" do
    assert_difference('Favoriteart.count', -1) do
      delete :destroy, id: @favoriteart
    end

    assert_redirected_to favoritearts_path
  end
end
