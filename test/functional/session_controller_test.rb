require 'test_helper'

class SessionControllerTest < ActionController::TestCase
    
  test "should get new" do
    get :new
    assert_response :success
  end

  test "should log in" do
    alice = users(:alice)
    post :create, name: alice.name, password: "secret"
    assert_equal session[:user_id], alice.id
    assert_equal session[:group_id], alice.group_id
  end

  test "should log out" do
    delete :destroy
    assert_equal session[:user_id], nil
    assert_equal session[:group_id], nil
  end
end
