require 'test_helper'

class NarrativesControllerTest < ActionController::TestCase
  setup do
    @narrative = narratives(:one)
  end

  test "should get index" do
    get :index
    assert_response :success
    assert_not_nil assigns(:narratives)
  end

  test "should get new" do
    get :new
    assert_response :success
  end

  test "should create narrative" do
    assert_difference('Narrative.count') do
      post :create, narrative: { created_on: @narrative.created_on, mp3: @narrative.mp3, ogg: @narrative.ogg, story: @narrative.story, subtopic_id: @narrative.subtopic_id, user_id: @narrative.user_id }
    end

    assert_redirected_to narrative_path(assigns(:narrative))
  end

  test "should show narrative" do
    get :show, id: @narrative
    assert_response :success
  end

  test "should get edit" do
    get :edit, id: @narrative
    assert_response :success
  end

  test "should update narrative" do
    put :update, id: @narrative, narrative: { created_on: @narrative.created_on, mp3: @narrative.mp3, ogg: @narrative.ogg, story: @narrative.story, subtopic_id: @narrative.subtopic_id, user_id: @narrative.user_id }
    assert_redirected_to narrative_path(assigns(:narrative))
  end

  test "should destroy narrative" do
    assert_difference('Narrative.count', -1) do
      delete :destroy, id: @narrative
    end

    assert_redirected_to narratives_path
  end
end
