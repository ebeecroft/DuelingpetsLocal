require 'test_helper'

class RegistrationsControllerTest < ActionController::TestCase
  setup do
    @registration = registrations(:one)
  end

  test "should get index" do
    get :index
    assert_response :success
    assert_not_nil assigns(:registrations)
  end

  test "should get new" do
    get :new
    assert_response :success
  end

  test "should create registration" do
    assert_difference('Registration.count') do
      post :create, registration: { admin: @registration.admin, birthday: @registration.birthday, country: @registration.country, country_timezone: @registration.country_timezone, email: @registration.email, first_name: @registration.first_name, joined_on: @registration.joined_on, last_name: @registration.last_name, login_id: @registration.login_id, password_digest: @registration.password_digest, vname: @registration.vname }
    end

    assert_redirected_to registration_path(assigns(:registration))
  end

  test "should show registration" do
    get :show, id: @registration
    assert_response :success
  end

  test "should get edit" do
    get :edit, id: @registration
    assert_response :success
  end

  test "should update registration" do
    put :update, id: @registration, registration: { admin: @registration.admin, birthday: @registration.birthday, country: @registration.country, country_timezone: @registration.country_timezone, email: @registration.email, first_name: @registration.first_name, joined_on: @registration.joined_on, last_name: @registration.last_name, login_id: @registration.login_id, password_digest: @registration.password_digest, vname: @registration.vname }
    assert_redirected_to registration_path(assigns(:registration))
  end

  test "should destroy registration" do
    assert_difference('Registration.count', -1) do
      delete :destroy, id: @registration
    end

    assert_redirected_to registrations_path
  end
end
