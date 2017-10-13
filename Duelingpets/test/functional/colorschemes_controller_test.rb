require 'test_helper'

class ColorschemesControllerTest < ActionController::TestCase
  setup do
    @colorscheme = colorschemes(:one)
  end

  test "should get index" do
    get :index
    assert_response :success
    assert_not_nil assigns(:colorschemes)
  end

  test "should get new" do
    get :new
    assert_response :success
  end

  test "should create colorscheme" do
    assert_difference('Colorscheme.count') do
      post :create, colorscheme: { errorcolor: @colorscheme.errorcolor, headercolour: @colorscheme.headercolour, name: @colorscheme.name, navigationcolor: @colorscheme.navigationcolor, navigationlinkcolor: @colorscheme.navigationlinkcolor, notificationcolor: @colorscheme.notificationcolor, onlinestatuscolor: @colorscheme.onlinestatuscolor, profilecolor: @colorscheme.profilecolor, successcolor: @colorscheme.successcolor, textcolour: @colorscheme.textcolour, warningcolor: @colorscheme.warningcolor }
    end

    assert_redirected_to colorscheme_path(assigns(:colorscheme))
  end

  test "should show colorscheme" do
    get :show, id: @colorscheme
    assert_response :success
  end

  test "should get edit" do
    get :edit, id: @colorscheme
    assert_response :success
  end

  test "should update colorscheme" do
    put :update, id: @colorscheme, colorscheme: { errorcolor: @colorscheme.errorcolor, headercolour: @colorscheme.headercolour, name: @colorscheme.name, navigationcolor: @colorscheme.navigationcolor, navigationlinkcolor: @colorscheme.navigationlinkcolor, notificationcolor: @colorscheme.notificationcolor, onlinestatuscolor: @colorscheme.onlinestatuscolor, profilecolor: @colorscheme.profilecolor, successcolor: @colorscheme.successcolor, textcolour: @colorscheme.textcolour, warningcolor: @colorscheme.warningcolor }
    assert_redirected_to colorscheme_path(assigns(:colorscheme))
  end

  test "should destroy colorscheme" do
    assert_difference('Colorscheme.count', -1) do
      delete :destroy, id: @colorscheme
    end

    assert_redirected_to colorschemes_path
  end
end
