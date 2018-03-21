require 'test_helper'

class BlacklisteddomainsControllerTest < ActionController::TestCase
  setup do
    @blacklisteddomain = blacklisteddomains(:one)
  end

  test "should get index" do
    get :index
    assert_response :success
    assert_not_nil assigns(:blacklisteddomains)
  end

  test "should get new" do
    get :new
    assert_response :success
  end

  test "should create blacklisteddomain" do
    assert_difference('Blacklisteddomain.count') do
      post :create, blacklisteddomain: { created_on: @blacklisteddomain.created_on, domain_only: @blacklisteddomain.domain_only, name: @blacklisteddomain.name }
    end

    assert_redirected_to blacklisteddomain_path(assigns(:blacklisteddomain))
  end

  test "should show blacklisteddomain" do
    get :show, id: @blacklisteddomain
    assert_response :success
  end

  test "should get edit" do
    get :edit, id: @blacklisteddomain
    assert_response :success
  end

  test "should update blacklisteddomain" do
    put :update, id: @blacklisteddomain, blacklisteddomain: { created_on: @blacklisteddomain.created_on, domain_only: @blacklisteddomain.domain_only, name: @blacklisteddomain.name }
    assert_redirected_to blacklisteddomain_path(assigns(:blacklisteddomain))
  end

  test "should destroy blacklisteddomain" do
    assert_difference('Blacklisteddomain.count', -1) do
      delete :destroy, id: @blacklisteddomain
    end

    assert_redirected_to blacklisteddomains_path
  end
end
