require 'test_helper'

class SignUpUserTest < ActionDispatch::IntegrationTest

  test "get new user form and sign up a new user" do
    @valid_user = User.new(username: "test", email: "test@test.com", password: "password", admin: false)

    get "/signup"
    assert_response :success
    
    assert_difference 'User.count', 1 do
      post users_path, params: { user: { username:  @valid_user.username, email:  @valid_user.email, password:   @valid_user.password } }
      assert_response :redirect
    end

    follow_redirect!
    assert_response :success
    assert_match "You have successfully signed up", response.body
  end

  test "get new user form and reject user registration" do
    @invalid_user_1 = User.new(username: "tt", email: "test@test.com", password: "password", admin: false)
    @invalid_user_2 = User.new(username: "test", email: "test@test", password: "password", admin: false)

    get "/signup"
    assert_response :success
    
    assert_no_difference 'User.count' do
      post users_path, params: { user: { username: @invalid_user_1.username, email: @invalid_user_1.email, password:  @invalid_user_1.password } }
    end
    assert_response :success
    assert_match "Username is too short", response.body
    assert_select 'div.alert'

    assert_no_difference 'User.count' do
      post users_path, params: { user: { username: @invalid_user_2.username, email: @invalid_user_2.email, password:  @invalid_user_2.password } }
    end
    assert_response :success
    assert_match "Email is invalid", response.body
    assert_select 'div.alert'
  end
end