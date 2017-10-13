require 'test_helper'

class ShoutsControllerTest < ActionController::TestCase
  setup do
    @shout = shouts(:one)
  end

  test "should get index" do
    get :index
    assert_response :success
    assert_not_nil assigns(:shouts)
  end

  test "should get new" do
    get :new
    assert_response :success
  end

  test "should create shout" do
    assert_difference('Shout.count') do
      post :create, shout: { created_on: @shout.created_on, from_user_id: @shout.from_user_id, message: @shout.message, user_id: @shout.user_id }
    end

    assert_redirected_to shout_path(assigns(:shout))
  end

  test "should show shout" do
    get :show, id: @shout
    assert_response :success
  end

  test "should get edit" do
    get :edit, id: @shout
    assert_response :success
  end

  test "should update shout" do
    put :update, id: @shout, shout: { created_on: @shout.created_on, from_user_id: @shout.from_user_id, message: @shout.message, user_id: @shout.user_id }
    assert_redirected_to shout_path(assigns(:shout))
  end

  test "should destroy shout" do
    assert_difference('Shout.count', -1) do
      delete :destroy, id: @shout
    end

    assert_redirected_to shouts_path
  end
end
