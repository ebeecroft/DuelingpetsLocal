require 'test_helper'

class ArtcommentsControllerTest < ActionController::TestCase
  setup do
    @artcomment = artcomments(:one)
  end

  test "should get index" do
    get :index
    assert_response :success
    assert_not_nil assigns(:artcomments)
  end

  test "should get new" do
    get :new
    assert_response :success
  end

  test "should create artcomment" do
    assert_difference('Artcomment.count') do
      post :create, artcomment: { art_id: @artcomment.art_id, created_on: @artcomment.created_on, critique: @artcomment.critique, message: @artcomment.message, user_id: @artcomment.user_id }
    end

    assert_redirected_to artcomment_path(assigns(:artcomment))
  end

  test "should show artcomment" do
    get :show, id: @artcomment
    assert_response :success
  end

  test "should get edit" do
    get :edit, id: @artcomment
    assert_response :success
  end

  test "should update artcomment" do
    put :update, id: @artcomment, artcomment: { art_id: @artcomment.art_id, created_on: @artcomment.created_on, critique: @artcomment.critique, message: @artcomment.message, user_id: @artcomment.user_id }
    assert_redirected_to artcomment_path(assigns(:artcomment))
  end

  test "should destroy artcomment" do
    assert_difference('Artcomment.count', -1) do
      delete :destroy, id: @artcomment
    end

    assert_redirected_to artcomments_path
  end
end
