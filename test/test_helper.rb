ENV["RAILS_ENV"] = "test"
require File.expand_path('../../config/environment', __FILE__)
require 'rails/test_help'

require 'authorization'

class ActiveSupport::TestCase

  module PermissionsTestHelpers
    # set the parameters to be passed in access tests
    def permission_test_params params = nil
      @permission_test_params = params unless params === nil
      @permission_test_params
    end

    # method is a HTTP method
    # action is a controller method
    # user can be a fixture or nil to log out
    def try_as method, action, user
        log_in user
        self.send(method, action, permission_test_params)
    end

    def succeed_as method, action, user
      try_as method, action, user
      assert [200, 302].include? response.response_code
    end

    def fail_as method, action, user
      try_as method, action, user
      assert_response 403
    end
  end

  module PermissionsDsl
    def admin_only method, action
      test "#{action.to_s} is admin only" do
        fail_as method, action, nil
        fail_as method, action ,users(:nobody)
        fail_as method, action ,users(:normal)
        succeed_as method, action ,users(:admin)
      end
    end
  end

  include PermissionsTestHelpers
  extend PermissionsDsl


  # Setup all fixtures in test/fixtures/*.(yml|csv) for all tests in alphabetical order.
  #
  # Note: You'll currently still have to declare fixtures explicitly in integration tests
  # -- they do not yet inherit this setting
  fixtures :all

  # Add more helper methods to be used by all tests here...

end
