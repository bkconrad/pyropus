require 'test_helper'

class SessionControllerTest < ActionController::TestCase
  include Authorization
    
  test "should get new" do
    get :new
    assert_response :success
  end

  test "should log in" do
    admin = users(:admin)
    post :create, name: admin.name, password: "secret"

    assert_equal User.find(session[:user_id]).id, admin.id
    assert_equal session[:user_id], admin.id

    assert_equal user_level, admin.group_id
    assert_equal session[:group_id], admin.group_id
  end

  test "should log out" do
    delete :destroy
    assert_equal session[:user_id], nil

    assert_equal session[:group_id], nil
    assert_equal user_level, nil
  end
end
