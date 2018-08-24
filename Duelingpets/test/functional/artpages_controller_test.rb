require 'test_helper'

class ArtpagesControllerTest < ActionController::TestCase
  setup do
    @artpage = artpages(:one)
  end

  test "should get index" do
    get :index
    assert_response :success
    assert_not_nil assigns(:artpages)
  end

  test "should get new" do
    get :new
    assert_response :success
  end

  test "should create artpage" do
    assert_difference('Artpage.count') do
      post :create, artpage: { art: @artpage.art, created_on: @artpage.created_on, message: @artpage.message, name: @artpage.name }
    end

    assert_redirected_to artpage_path(assigns(:artpage))
  end

  test "should show artpage" do
    get :show, id: @artpage
    assert_response :success
  end

  test "should get edit" do
    get :edit, id: @artpage
    assert_response :success
  end

  test "should update artpage" do
    put :update, id: @artpage, artpage: { art: @artpage.art, created_on: @artpage.created_on, message: @artpage.message, name: @artpage.name }
    assert_redirected_to artpage_path(assigns(:artpage))
  end

  test "should destroy artpage" do
    assert_difference('Artpage.count', -1) do
      delete :destroy, id: @artpage
    end

    assert_redirected_to artpages_path
  end
end
