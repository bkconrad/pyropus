require 'test_helper'

class ThingsControllerTest < ActionController::TestCase
  include Authorization

  admin_action :new, :create, :edit, :update, :destroy
  public_action :show, :index

  setup do
    log_in users(:admin)
    @thing = things(:one)
    permission_test_params thing: { name: 'hi', description: 'ho'}, id: @thing.id
  end

  test "should get index" do
    get :index
    assert_response :success
    assert_not_nil assigns(:things)
  end

  test "should get new" do
    get :new
    assert_response :success
  end

  test "should create thing" do
    assert_difference('Thing.count') do
      post :create, thing: @thing.attributes
    end

    assert_redirected_to thing_path(assigns(:thing))
  end

  test "should show thing" do
    get :show, id: @thing
    assert_response :success
  end

  test "should get edit" do
    get :edit, id: @thing
    assert_response :success
  end

  test "should update thing" do
    put :update, id: @thing, thing: @thing.attributes
    assert_redirected_to thing_path(assigns(:thing))
  end

  test "should destroy thing" do
    assert_difference('Thing.count', -1) do
      delete :destroy, id: @thing
    end

    assert_redirected_to things_path
  end
end
