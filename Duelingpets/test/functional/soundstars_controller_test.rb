require 'test_helper'

class SoundstarsControllerTest < ActionController::TestCase
  setup do
    @soundstar = soundstars(:one)
  end

  test "should get index" do
    get :index
    assert_response :success
    assert_not_nil assigns(:soundstars)
  end

  test "should get new" do
    get :new
    assert_response :success
  end

  test "should create soundstar" do
    assert_difference('Soundstar.count') do
      post :create, soundstar: { created_on: @soundstar.created_on, sound_id: @soundstar.sound_id, user_id: @soundstar.user_id }
    end

    assert_redirected_to soundstar_path(assigns(:soundstar))
  end

  test "should show soundstar" do
    get :show, id: @soundstar
    assert_response :success
  end

  test "should get edit" do
    get :edit, id: @soundstar
    assert_response :success
  end

  test "should update soundstar" do
    put :update, id: @soundstar, soundstar: { created_on: @soundstar.created_on, sound_id: @soundstar.sound_id, user_id: @soundstar.user_id }
    assert_redirected_to soundstar_path(assigns(:soundstar))
  end

  test "should destroy soundstar" do
    assert_difference('Soundstar.count', -1) do
      delete :destroy, id: @soundstar
    end

    assert_redirected_to soundstars_path
  end
end
