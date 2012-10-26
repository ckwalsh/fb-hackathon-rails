require 'test_helper'

class EventSourcesControllerTest < ActionController::TestCase
  setup do
    @event_source = event_sources(:one)
  end

  test "should get index" do
    get :index
    assert_response :success
    assert_not_nil assigns(:event_sources)
  end

  test "should get new" do
    get :new
    assert_response :success
  end

  test "should create event_source" do
    assert_difference('EventSource.count') do
      post :create, :event_source => { :fbid => @event_source.fbid }
    end

    assert_redirected_to event_source_path(assigns(:event_source))
  end

  test "should show event_source" do
    get :show, :id => @event_source
    assert_response :success
  end

  test "should get edit" do
    get :edit, :id => @event_source
    assert_response :success
  end

  test "should update event_source" do
    put :update, :id => @event_source, :event_source => { :fbid => @event_source.fbid }
    assert_redirected_to event_source_path(assigns(:event_source))
  end

  test "should destroy event_source" do
    assert_difference('EventSource.count', -1) do
      delete :destroy, :id => @event_source
    end

    assert_redirected_to event_sources_path
  end
end
