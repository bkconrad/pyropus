class ApplicationController < ActionController::Base
  protect_from_forgery
  before_filter :authorize, :store_return_to

  include LoginRedirection
  include Authorization

end
