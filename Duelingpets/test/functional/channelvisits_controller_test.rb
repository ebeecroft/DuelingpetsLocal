require 'test_helper'

class ChannelvisitsControllerTest < ActionController::TestCase
  setup do
    @channelvisit = channelvisits(:one)
  end

  test "should get index" do
    get :index
    assert_response :success
    assert_not_nil assigns(:channelvisits)
  end

  test "should get new" do
    get :new
    assert_response :success
  end

  test "should create channelvisit" do
    assert_difference('Channelvisit.count') do
      post :create, channelvisit: { channel_id: @channelvisit.channel_id, created_on: @channelvisit.created_on, user_id: @channelvisit.user_id }
    end

    assert_redirected_to channelvisit_path(assigns(:channelvisit))
  end

  test "should show channelvisit" do
    get :show, id: @channelvisit
    assert_response :success
  end

  test "should get edit" do
    get :edit, id: @channelvisit
    assert_response :success
  end

  test "should update channelvisit" do
    put :update, id: @channelvisit, channelvisit: { channel_id: @channelvisit.channel_id, created_on: @channelvisit.created_on, user_id: @channelvisit.user_id }
    assert_redirected_to channelvisit_path(assigns(:channelvisit))
  end

  test "should destroy channelvisit" do
    assert_difference('Channelvisit.count', -1) do
      delete :destroy, id: @channelvisit
    end

    assert_redirected_to channelvisits_path
  end
end
