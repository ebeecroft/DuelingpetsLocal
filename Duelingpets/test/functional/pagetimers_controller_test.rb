require 'test_helper'

class PagetimersControllerTest < ActionController::TestCase
  setup do
    @pagetimer = pagetimers(:one)
  end

  test "should get index" do
    get :index
    assert_response :success
    assert_not_nil assigns(:pagetimers)
  end

  test "should get new" do
    get :new
    assert_response :success
  end

  test "should create pagetimer" do
    assert_difference('Pagetimer.count') do
      post :create, pagetimer: { duration: @pagetimer.duration, expiretime: @pagetimer.expiretime, name: @pagetimer.name, timeformat: @pagetimer.timeformat }
    end

    assert_redirected_to pagetimer_path(assigns(:pagetimer))
  end

  test "should show pagetimer" do
    get :show, id: @pagetimer
    assert_response :success
  end

  test "should get edit" do
    get :edit, id: @pagetimer
    assert_response :success
  end

  test "should update pagetimer" do
    put :update, id: @pagetimer, pagetimer: { duration: @pagetimer.duration, expiretime: @pagetimer.expiretime, name: @pagetimer.name, timeformat: @pagetimer.timeformat }
    assert_redirected_to pagetimer_path(assigns(:pagetimer))
  end

  test "should destroy pagetimer" do
    assert_difference('Pagetimer.count', -1) do
      delete :destroy, id: @pagetimer
    end

    assert_redirected_to pagetimers_path
  end
end
