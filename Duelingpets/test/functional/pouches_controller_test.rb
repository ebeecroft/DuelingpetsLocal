require 'test_helper'

class PouchesControllerTest < ActionController::TestCase
  setup do
    @pouch = pouches(:one)
  end

  test "should get index" do
    get :index
    assert_response :success
    assert_not_nil assigns(:pouches)
  end

  test "should get new" do
    get :new
    assert_response :success
  end

  test "should create pouch" do
    assert_difference('Pouch.count') do
      post :create, pouch: { activated: @pouch.activated, amount: @pouch.amount, expiretime: @pouch.expiretime, last_visited: @pouch.last_visited, remember_token: @pouch.remember_token, signed_in_at: @pouch.signed_in_at, signed_out_at: @pouch.signed_out_at, user_id: @pouch.user_id }
    end

    assert_redirected_to pouch_path(assigns(:pouch))
  end

  test "should show pouch" do
    get :show, id: @pouch
    assert_response :success
  end

  test "should get edit" do
    get :edit, id: @pouch
    assert_response :success
  end

  test "should update pouch" do
    put :update, id: @pouch, pouch: { activated: @pouch.activated, amount: @pouch.amount, expiretime: @pouch.expiretime, last_visited: @pouch.last_visited, remember_token: @pouch.remember_token, signed_in_at: @pouch.signed_in_at, signed_out_at: @pouch.signed_out_at, user_id: @pouch.user_id }
    assert_redirected_to pouch_path(assigns(:pouch))
  end

  test "should destroy pouch" do
    assert_difference('Pouch.count', -1) do
      delete :destroy, id: @pouch
    end

    assert_redirected_to pouches_path
  end
end
