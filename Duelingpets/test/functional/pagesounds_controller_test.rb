require 'test_helper'

class PagesoundsControllerTest < ActionController::TestCase
  setup do
    @pagesound = pagesounds(:one)
  end

  test "should get index" do
    get :index
    assert_response :success
    assert_not_nil assigns(:pagesounds)
  end

  test "should get new" do
    get :new
    assert_response :success
  end

  test "should create pagesound" do
    assert_difference('Pagesound.count') do
      post :create, pagesound: { created_on: @pagesound.created_on, mp3: @pagesound.mp3, name: @pagesound.name, ogg: @pagesound.ogg }
    end

    assert_redirected_to pagesound_path(assigns(:pagesound))
  end

  test "should show pagesound" do
    get :show, id: @pagesound
    assert_response :success
  end

  test "should get edit" do
    get :edit, id: @pagesound
    assert_response :success
  end

  test "should update pagesound" do
    put :update, id: @pagesound, pagesound: { created_on: @pagesound.created_on, mp3: @pagesound.mp3, name: @pagesound.name, ogg: @pagesound.ogg }
    assert_redirected_to pagesound_path(assigns(:pagesound))
  end

  test "should destroy pagesound" do
    assert_difference('Pagesound.count', -1) do
      delete :destroy, id: @pagesound
    end

    assert_redirected_to pagesounds_path
  end
end
