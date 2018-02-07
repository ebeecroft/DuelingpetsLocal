require 'test_helper'

class ForumgroupsControllerTest < ActionController::TestCase
  setup do
    @forumgroup = forumgroups(:one)
  end

  test "should get index" do
    get :index
    assert_response :success
    assert_not_nil assigns(:forumgroups)
  end

  test "should get new" do
    get :new
    assert_response :success
  end

  test "should create forumgroup" do
    assert_difference('Forumgroup.count') do
      post :create, forumgroup: { created_on: @forumgroup.created_on, name: @forumgroup.name }
    end

    assert_redirected_to forumgroup_path(assigns(:forumgroup))
  end

  test "should show forumgroup" do
    get :show, id: @forumgroup
    assert_response :success
  end

  test "should get edit" do
    get :edit, id: @forumgroup
    assert_response :success
  end

  test "should update forumgroup" do
    put :update, id: @forumgroup, forumgroup: { created_on: @forumgroup.created_on, name: @forumgroup.name }
    assert_redirected_to forumgroup_path(assigns(:forumgroup))
  end

  test "should destroy forumgroup" do
    assert_difference('Forumgroup.count', -1) do
      delete :destroy, id: @forumgroup
    end

    assert_redirected_to forumgroups_path
  end
end
