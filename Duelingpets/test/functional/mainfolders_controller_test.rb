require 'test_helper'

class MainfoldersControllerTest < ActionController::TestCase
  setup do
    @mainfolder = mainfolders(:one)
  end

  test "should get index" do
    get :index
    assert_response :success
    assert_not_nil assigns(:mainfolders)
  end

  test "should get new" do
    get :new
    assert_response :success
  end

  test "should create mainfolder" do
    assert_difference('Mainfolder.count') do
      post :create, mainfolder: { created_on: @mainfolder.created_on, description: @mainfolder.description, gallery_id: @mainfolder.gallery_id, title: @mainfolder.title, user_id: @mainfolder.user_id }
    end

    assert_redirected_to mainfolder_path(assigns(:mainfolder))
  end

  test "should show mainfolder" do
    get :show, id: @mainfolder
    assert_response :success
  end

  test "should get edit" do
    get :edit, id: @mainfolder
    assert_response :success
  end

  test "should update mainfolder" do
    put :update, id: @mainfolder, mainfolder: { created_on: @mainfolder.created_on, description: @mainfolder.description, gallery_id: @mainfolder.gallery_id, title: @mainfolder.title, user_id: @mainfolder.user_id }
    assert_redirected_to mainfolder_path(assigns(:mainfolder))
  end

  test "should destroy mainfolder" do
    assert_difference('Mainfolder.count', -1) do
      delete :destroy, id: @mainfolder
    end

    assert_redirected_to mainfolders_path
  end
end
