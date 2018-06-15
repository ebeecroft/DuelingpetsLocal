require 'test_helper'

class WebbannersControllerTest < ActionController::TestCase
  setup do
    @webbanner = webbanners(:one)
  end

  test "should get index" do
    get :index
    assert_response :success
    assert_not_nil assigns(:webbanners)
  end

  test "should get new" do
    get :new
    assert_response :success
  end

  test "should create webbanner" do
    assert_difference('Webbanner.count') do
      post :create, webbanner: { banner: @webbanner.banner, created_on: @webbanner.created_on, name: @webbanner.name }
    end

    assert_redirected_to webbanner_path(assigns(:webbanner))
  end

  test "should show webbanner" do
    get :show, id: @webbanner
    assert_response :success
  end

  test "should get edit" do
    get :edit, id: @webbanner
    assert_response :success
  end

  test "should update webbanner" do
    put :update, id: @webbanner, webbanner: { banner: @webbanner.banner, created_on: @webbanner.created_on, name: @webbanner.name }
    assert_redirected_to webbanner_path(assigns(:webbanner))
  end

  test "should destroy webbanner" do
    assert_difference('Webbanner.count', -1) do
      delete :destroy, id: @webbanner
    end

    assert_redirected_to webbanners_path
  end
end
