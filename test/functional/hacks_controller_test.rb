require 'test_helper'

class HacksControllerTest < ActionController::TestCase
  setup do
    @hack = hacks(:one)
  end

  test "should get index" do
    get :index
    assert_response :success
    assert_not_nil assigns(:hacks)
  end

  test "should get new" do
    get :new
    assert_response :success
  end

  test "should create hack" do
    assert_difference('Hack.count') do
      post :create, :hack => { :description => @hack.description, :event_id => @hack.event_id, :image_url => @hack.image_url, :name => @hack.name, :source_url => @hack.source_url, :url => @hack.url }
    end

    assert_redirected_to hack_path(assigns(:hack))
  end

  test "should show hack" do
    get :show, :id => @hack
    assert_response :success
  end

  test "should get edit" do
    get :edit, :id => @hack
    assert_response :success
  end

  test "should update hack" do
    put :update, :id => @hack, :hack => { :description => @hack.description, :event_id => @hack.event_id, :image_url => @hack.image_url, :name => @hack.name, :source_url => @hack.source_url, :url => @hack.url }
    assert_redirected_to hack_path(assigns(:hack))
  end

  test "should destroy hack" do
    assert_difference('Hack.count', -1) do
      delete :destroy, :id => @hack
    end

    assert_redirected_to hacks_path
  end
end
