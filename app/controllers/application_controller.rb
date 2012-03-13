class ApplicationController < ActionController::Base
  protect_from_forgery
  before_filter :authorize

  def authorize
    # TODO: figure out how/where to define user level constants
    if session[:group_id] != nil
      return session[:group_id] > 1
    end
    redirect_to login_url, alert: "Please login to do that", redirect: "test"
  end
end
