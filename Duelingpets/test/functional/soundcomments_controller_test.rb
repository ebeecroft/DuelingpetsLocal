require 'test_helper'

class SoundcommentsControllerTest < ActionController::TestCase
  setup do
    @soundcomment = soundcomments(:one)
  end

  test "should get index" do
    get :index
    assert_response :success
    assert_not_nil assigns(:soundcomments)
  end

  test "should get new" do
    get :new
    assert_response :success
  end

  test "should create soundcomment" do
    assert_difference('Soundcomment.count') do
      post :create, soundcomment: { created_on: @soundcomment.created_on, critique: @soundcomment.critique, message: @soundcomment.message, sound_id: @soundcomment.sound_id, user_id: @soundcomment.user_id }
    end

    assert_redirected_to soundcomment_path(assigns(:soundcomment))
  end

  test "should show soundcomment" do
    get :show, id: @soundcomment
    assert_response :success
  end

  test "should get edit" do
    get :edit, id: @soundcomment
    assert_response :success
  end

  test "should update soundcomment" do
    put :update, id: @soundcomment, soundcomment: { created_on: @soundcomment.created_on, critique: @soundcomment.critique, message: @soundcomment.message, sound_id: @soundcomment.sound_id, user_id: @soundcomment.user_id }
    assert_redirected_to soundcomment_path(assigns(:soundcomment))
  end

  test "should destroy soundcomment" do
    assert_difference('Soundcomment.count', -1) do
      delete :destroy, id: @soundcomment
    end

    assert_redirected_to soundcomments_path
  end
end
