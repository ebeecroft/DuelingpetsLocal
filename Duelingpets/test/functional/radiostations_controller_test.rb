require 'test_helper'

class RadiostationsControllerTest < ActionController::TestCase
  setup do
    @radiostation = radiostations(:one)
  end

  test "should get index" do
    get :index
    assert_response :success
    assert_not_nil assigns(:radiostations)
  end

  test "should get new" do
    get :new
    assert_response :success
  end

  test "should create radiostation" do
    assert_difference('Radiostation.count') do
      post :create, radiostation: { created_on: @radiostation.created_on, description: @radiostation.description, mp4: @radiostation.mp4, name: @radiostation.name, ogv: @radiostation.ogv, user_id: @radiostation.user_id, video_on: @radiostation.video_on }
    end

    assert_redirected_to radiostation_path(assigns(:radiostation))
  end

  test "should show radiostation" do
    get :show, id: @radiostation
    assert_response :success
  end

  test "should get edit" do
    get :edit, id: @radiostation
    assert_response :success
  end

  test "should update radiostation" do
    put :update, id: @radiostation, radiostation: { created_on: @radiostation.created_on, description: @radiostation.description, mp4: @radiostation.mp4, name: @radiostation.name, ogv: @radiostation.ogv, user_id: @radiostation.user_id, video_on: @radiostation.video_on }
    assert_redirected_to radiostation_path(assigns(:radiostation))
  end

  test "should destroy radiostation" do
    assert_difference('Radiostation.count', -1) do
      delete :destroy, id: @radiostation
    end

    assert_redirected_to radiostations_path
  end
end
