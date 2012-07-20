ENV["RAILS_ENV"] = "test"
require File.expand_path('../../config/environment', __FILE__)
require 'rails/test_help'

require 'authorization'

class ActiveSupport::TestCase
  # Setup all fixtures in test/fixtures/*.(yml|csv) for all tests in alphabetical order.
  #
  # Note: You'll currently still have to declare fixtures explicitly in integration tests
  # -- they do not yet inherit this setting
  fixtures :all

  # Add more helper methods to be used by all tests here...

  # set the parameters to be passed in access tests
  def permission_test_params params = nil
    @permission_test_params = params unless params === nil
    @permission_test_params
  end

  def self.admin_only method, action
    test "#{action.to_s} is admin only" do
      log_out
      self.send(method, action, permission_test_params)
      assert_response 403

      log_in users(:nobody)
      self.send(method, action, permission_test_params)
      assert_response 403

      log_in users(:normal)
      self.send(method, action, permission_test_params)
      assert_response 403

      log_in users(:admin)
      self.send(method, action, permission_test_params)
      assert_response 200
    end
  end
end
