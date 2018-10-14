require 'test_helper'

class RadiostationvisitsControllerTest < ActionController::TestCase
  setup do
    @radiostationvisit = radiostationvisits(:one)
  end

  test "should get index" do
    get :index
    assert_response :success
    assert_not_nil assigns(:radiostationvisits)
  end

  test "should get new" do
    get :new
    assert_response :success
  end

  test "should create radiostationvisit" do
    assert_difference('Radiostationvisit.count') do
      post :create, radiostationvisit: { created_on: @radiostationvisit.created_on, radiostation_id: @radiostationvisit.radiostation_id, user_id: @radiostationvisit.user_id }
    end

    assert_redirected_to radiostationvisit_path(assigns(:radiostationvisit))
  end

  test "should show radiostationvisit" do
    get :show, id: @radiostationvisit
    assert_response :success
  end

  test "should get edit" do
    get :edit, id: @radiostationvisit
    assert_response :success
  end

  test "should update radiostationvisit" do
    put :update, id: @radiostationvisit, radiostationvisit: { created_on: @radiostationvisit.created_on, radiostation_id: @radiostationvisit.radiostation_id, user_id: @radiostationvisit.user_id }
    assert_redirected_to radiostationvisit_path(assigns(:radiostationvisit))
  end

  test "should destroy radiostationvisit" do
    assert_difference('Radiostationvisit.count', -1) do
      delete :destroy, id: @radiostationvisit
    end

    assert_redirected_to radiostationvisits_path
  end
end
