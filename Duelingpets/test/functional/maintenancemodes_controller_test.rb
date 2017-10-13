require 'test_helper'

class MaintenancemodesControllerTest < ActionController::TestCase
  setup do
    @maintenancemode = maintenancemodes(:one)
  end

  test "should get index" do
    get :index
    assert_response :success
    assert_not_nil assigns(:maintenancemodes)
  end

  test "should get new" do
    get :new
    assert_response :success
  end

  test "should create maintenancemode" do
    assert_difference('Maintenancemode.count') do
      post :create, maintenancemode: { created_on: @maintenancemode.created_on, maintenance_on: @maintenancemode.maintenance_on, name: @maintenancemode.name }
    end

    assert_redirected_to maintenancemode_path(assigns(:maintenancemode))
  end

  test "should show maintenancemode" do
    get :show, id: @maintenancemode
    assert_response :success
  end

  test "should get edit" do
    get :edit, id: @maintenancemode
    assert_response :success
  end

  test "should update maintenancemode" do
    put :update, id: @maintenancemode, maintenancemode: { created_on: @maintenancemode.created_on, maintenance_on: @maintenancemode.maintenance_on, name: @maintenancemode.name }
    assert_redirected_to maintenancemode_path(assigns(:maintenancemode))
  end

  test "should destroy maintenancemode" do
    assert_difference('Maintenancemode.count', -1) do
      delete :destroy, id: @maintenancemode
    end

    assert_redirected_to maintenancemodes_path
  end
end
