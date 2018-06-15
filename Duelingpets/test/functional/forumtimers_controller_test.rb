require 'test_helper'

class ForumtimersControllerTest < ActionController::TestCase
  setup do
    @forumtimer = forumtimers(:one)
  end

  test "should get index" do
    get :index
    assert_response :success
    assert_not_nil assigns(:forumtimers)
  end

  test "should get new" do
    get :new
    assert_response :success
  end

  test "should create forumtimer" do
    assert_difference('Forumtimer.count') do
      post :create, forumtimer: { forum_id: @forumtimer.forum_id, forumowner_last_visited: @forumtimer.forumowner_last_visited, guest_last_visited: @forumtimer.guest_last_visited, member_last_visited: @forumtimer.member_last_visited, moderator_last_visited: @forumtimer.moderator_last_visited }
    end

    assert_redirected_to forumtimer_path(assigns(:forumtimer))
  end

  test "should show forumtimer" do
    get :show, id: @forumtimer
    assert_response :success
  end

  test "should get edit" do
    get :edit, id: @forumtimer
    assert_response :success
  end

  test "should update forumtimer" do
    put :update, id: @forumtimer, forumtimer: { forum_id: @forumtimer.forum_id, forumowner_last_visited: @forumtimer.forumowner_last_visited, guest_last_visited: @forumtimer.guest_last_visited, member_last_visited: @forumtimer.member_last_visited, moderator_last_visited: @forumtimer.moderator_last_visited }
    assert_redirected_to forumtimer_path(assigns(:forumtimer))
  end

  test "should destroy forumtimer" do
    assert_difference('Forumtimer.count', -1) do
      delete :destroy, id: @forumtimer
    end

    assert_redirected_to forumtimers_path
  end
end
