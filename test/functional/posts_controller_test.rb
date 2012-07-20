require 'test_helper'

class PostsControllerTest < ActionController::TestCase
  include Authorization

  admin_only :get, :new
  admin_only :get, :create
  admin_only :get, :edit
  admin_only :post, :update
  admin_only :delete, :destroy

  setup do
    log_in users(:admin)
    @post = posts(:one)
    permission_test_params post: { title: 'hi', content: 'ho'}, id: @post.id
  end

  test "should get index" do
    get :index
    assert_response :success
    assert_not_nil assigns(:posts)
  end

  test "should get new" do
    get :new
    assert_response :success
  end

  test "should create post" do
    assert_difference('Post.count') do
      post :create, post: @post.attributes
    end

    assert_redirected_to post_path(assigns(:post))
  end

  test "should show post" do
    get :show, id: @post
    assert_response :success
  end

  test "should get edit" do
    get :edit, id: @post
    assert_response :success
  end

  test "should update post" do
    put :update, id: @post, post: @post.attributes
    assert_redirected_to post_path(assigns(:post))
  end

  test "should destroy post" do
    assert_difference('Post.count', -1) do
      delete :destroy, id: @post
    end

    assert_redirected_to posts_path
  end
end
