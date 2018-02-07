require 'test_helper'

class FavoritesoundsControllerTest < ActionController::TestCase
  setup do
    @favoritesound = favoritesounds(:one)
  end

  test "should get index" do
    get :index
    assert_response :success
    assert_not_nil assigns(:favoritesounds)
  end

  test "should get new" do
    get :new
    assert_response :success
  end

  test "should create favoritesound" do
    assert_difference('Favoritesound.count') do
      post :create, favoritesound: { created_on: @favoritesound.created_on, sound_id: @favoritesound.sound_id, subsheet_id: @favoritesound.subsheet_id, user_id: @favoritesound.user_id }
    end

    assert_redirected_to favoritesound_path(assigns(:favoritesound))
  end

  test "should show favoritesound" do
    get :show, id: @favoritesound
    assert_response :success
  end

  test "should get edit" do
    get :edit, id: @favoritesound
    assert_response :success
  end

  test "should update favoritesound" do
    put :update, id: @favoritesound, favoritesound: { created_on: @favoritesound.created_on, sound_id: @favoritesound.sound_id, subsheet_id: @favoritesound.subsheet_id, user_id: @favoritesound.user_id }
    assert_redirected_to favoritesound_path(assigns(:favoritesound))
  end

  test "should destroy favoritesound" do
    assert_difference('Favoritesound.count', -1) do
      delete :destroy, id: @favoritesound
    end

    assert_redirected_to favoritesounds_path
  end
end
