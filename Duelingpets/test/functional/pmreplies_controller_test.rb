require 'test_helper'

class PmrepliesControllerTest < ActionController::TestCase
  setup do
    @pmreply = pmreplies(:one)
  end

  test "should get index" do
    get :index
    assert_response :success
    assert_not_nil assigns(:pmreplies)
  end

  test "should get new" do
    get :new
    assert_response :success
  end

  test "should create pmreply" do
    assert_difference('Pmreply.count') do
      post :create, pmreply: { created_on: @pmreply.created_on, message: @pmreply.message, pm_id: @pmreply.pm_id, user_id: @pmreply.user_id }
    end

    assert_redirected_to pmreply_path(assigns(:pmreply))
  end

  test "should show pmreply" do
    get :show, id: @pmreply
    assert_response :success
  end

  test "should get edit" do
    get :edit, id: @pmreply
    assert_response :success
  end

  test "should update pmreply" do
    put :update, id: @pmreply, pmreply: { created_on: @pmreply.created_on, message: @pmreply.message, pm_id: @pmreply.pm_id, user_id: @pmreply.user_id }
    assert_redirected_to pmreply_path(assigns(:pmreply))
  end

  test "should destroy pmreply" do
    assert_difference('Pmreply.count', -1) do
      delete :destroy, id: @pmreply
    end

    assert_redirected_to pmreplies_path
  end
end
