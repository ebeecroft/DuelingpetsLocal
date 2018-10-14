require 'test_helper'

class ArtvisitsControllerTest < ActionController::TestCase
  setup do
    @artvisit = artvisits(:one)
  end

  test "should get index" do
    get :index
    assert_response :success
    assert_not_nil assigns(:artvisits)
  end

  test "should get new" do
    get :new
    assert_response :success
  end

  test "should create artvisit" do
    assert_difference('Artvisit.count') do
      post :create, artvisit: { art_id: @artvisit.art_id, created_on: @artvisit.created_on, user_id: @artvisit.user_id }
    end

    assert_redirected_to artvisit_path(assigns(:artvisit))
  end

  test "should show artvisit" do
    get :show, id: @artvisit
    assert_response :success
  end

  test "should get edit" do
    get :edit, id: @artvisit
    assert_response :success
  end

  test "should update artvisit" do
    put :update, id: @artvisit, artvisit: { art_id: @artvisit.art_id, created_on: @artvisit.created_on, user_id: @artvisit.user_id }
    assert_redirected_to artvisit_path(assigns(:artvisit))
  end

  test "should destroy artvisit" do
    assert_difference('Artvisit.count', -1) do
      delete :destroy, id: @artvisit
    end

    assert_redirected_to artvisits_path
  end
end
