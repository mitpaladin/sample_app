require 'test_helper'

class UsersLoginTest < ActionDispatch::IntegrationTest

  def setup
    @user = users(:michael)
  end

  test "login with invalid information" do
    get login_path
    assert_template 'sessions/new'
    post sessions_path, session: { email: "", password: "" }
    assert_template 'sessions/new'
    assert_not flash.empty?
    get root_path
    assert flash.empty?
  end

  test "login with valid information" do
    get login_path
    post sessions_path, session: { email: @user.email, password: 'password' }
    assert _logged_in?
    assert_redirected_to user_path(@user)
    follow_redirect!
    assert_template 'users/show'
    assert_select "a[href=#{login_path}]", count: 0
    assert_select "a[href=#{logout_path}]"
    assert_select "a[href=#{user_path(@user)}]"
    delete logout_path
    assert_not _logged_in?
    assert_redirected_to root_url
    follow_redirect!
    assert_select "a[href=#{login_path}]"
    assert_select "a[href=#{logout_path}]",      count: 0
    assert_select "a[href=#{user_path(@user)}]", count: 0
  end

  test "login with remembering" do
    _log_in(@user, remember_me: '1')
    assert_not_nil cookies['remember_token']
  end

  test "login without remembering" do
    _log_in(@user, remember_me: '0')
    assert_nil cookies['remember_token']
  end

  test "remembering a user" do
    _log_in(@user)
    assert _logged_in?
    _close_browser
    assert_not _logged_in?
    get root_path
    assert _logged_in?
  end
end