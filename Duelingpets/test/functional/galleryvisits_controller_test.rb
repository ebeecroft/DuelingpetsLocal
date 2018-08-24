require 'test_helper'

class GalleryvisitsControllerTest < ActionController::TestCase
  setup do
    @galleryvisit = galleryvisits(:one)
  end

  test "should get index" do
    get :index
    assert_response :success
    assert_not_nil assigns(:galleryvisits)
  end

  test "should get new" do
    get :new
    assert_response :success
  end

  test "should create galleryvisit" do
    assert_difference('Galleryvisit.count') do
      post :create, galleryvisit: { created_on: @galleryvisit.created_on, gallery_id: @galleryvisit.gallery_id, user_id: @galleryvisit.user_id }
    end

    assert_redirected_to galleryvisit_path(assigns(:galleryvisit))
  end

  test "should show galleryvisit" do
    get :show, id: @galleryvisit
    assert_response :success
  end

  test "should get edit" do
    get :edit, id: @galleryvisit
    assert_response :success
  end

  test "should update galleryvisit" do
    put :update, id: @galleryvisit, galleryvisit: { created_on: @galleryvisit.created_on, gallery_id: @galleryvisit.gallery_id, user_id: @galleryvisit.user_id }
    assert_redirected_to galleryvisit_path(assigns(:galleryvisit))
  end

  test "should destroy galleryvisit" do
    assert_difference('Galleryvisit.count', -1) do
      delete :destroy, id: @galleryvisit
    end

    assert_redirected_to galleryvisits_path
  end
end
