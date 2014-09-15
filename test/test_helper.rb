ENV['RAILS_ENV'] ||= 'test'

class ActiveSupport::TestCase
  fixtures :all

  # Returns true if a test user is logged in.
  def _logged_in?
    !session[:user_id].nil?
  end

  # Logs in a test user.
  def _log_in(user, options = {})
    password    = options[:password]    || 'password'
    remember_me = options[:remember_me] || '1'
    if integration_test?
      post sessions_path, session: { email:       user.email,
                                     password:    password,
                                     remember_me: remember_me }
    else
      session[:user_id] = user.id
    end
  end

  # Simulates closing the browser.
  # The effect is to delete the session but not the permanent cookies.
  def _close_browser
    delete close_path
  end

  private

    # Returns true inside an integration test.
    def integration_test?
      defined?(post_via_redirect)
    end
end