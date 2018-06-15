require 'test_helper'

class ForuminvitemembersControllerTest < ActionController::TestCase
  setup do
    @foruminvitemember = foruminvitemembers(:one)
  end

  test "should get index" do
    get :index
    assert_response :success
    assert_not_nil assigns(:foruminvitemembers)
  end

  test "should get new" do
    get :new
    assert_response :success
  end

  test "should create foruminvitemember" do
    assert_difference('Foruminvitemember.count') do
      post :create, foruminvitemember: { created_on: @foruminvitemember.created_on, forum_id: @foruminvitemember.forum_id, user_id: @foruminvitemember.user_id }
    end

    assert_redirected_to foruminvitemember_path(assigns(:foruminvitemember))
  end

  test "should show foruminvitemember" do
    get :show, id: @foruminvitemember
    assert_response :success
  end

  test "should get edit" do
    get :edit, id: @foruminvitemember
    assert_response :success
  end

  test "should update foruminvitemember" do
    put :update, id: @foruminvitemember, foruminvitemember: { created_on: @foruminvitemember.created_on, forum_id: @foruminvitemember.forum_id, user_id: @foruminvitemember.user_id }
    assert_redirected_to foruminvitemember_path(assigns(:foruminvitemember))
  end

  test "should destroy foruminvitemember" do
    assert_difference('Foruminvitemember.count', -1) do
      delete :destroy, id: @foruminvitemember
    end

    assert_redirected_to foruminvitemembers_path
  end
end
