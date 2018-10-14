require 'test_helper'

class SoundvisitsControllerTest < ActionController::TestCase
  setup do
    @soundvisit = soundvisits(:one)
  end

  test "should get index" do
    get :index
    assert_response :success
    assert_not_nil assigns(:soundvisits)
  end

  test "should get new" do
    get :new
    assert_response :success
  end

  test "should create soundvisit" do
    assert_difference('Soundvisit.count') do
      post :create, soundvisit: { created_on: @soundvisit.created_on, sound_id: @soundvisit.sound_id, user_id: @soundvisit.user_id }
    end

    assert_redirected_to soundvisit_path(assigns(:soundvisit))
  end

  test "should show soundvisit" do
    get :show, id: @soundvisit
    assert_response :success
  end

  test "should get edit" do
    get :edit, id: @soundvisit
    assert_response :success
  end

  test "should update soundvisit" do
    put :update, id: @soundvisit, soundvisit: { created_on: @soundvisit.created_on, sound_id: @soundvisit.sound_id, user_id: @soundvisit.user_id }
    assert_redirected_to soundvisit_path(assigns(:soundvisit))
  end

  test "should destroy soundvisit" do
    assert_difference('Soundvisit.count', -1) do
      delete :destroy, id: @soundvisit
    end

    assert_redirected_to soundvisits_path
  end
end
