class ApplicationController < ActionController::Base
  protect_from_forgery
  before_filter :authorize, :store_return_to

  def store_return_to
    session[:return_to] = request.url
  end

  def redirect_back
    if session[:return_to]
      redirect_to session[:return_to]
    else
      redirect_to login_url
    end
    session[:return_to] = nil
  end

  def authorize
    # TODO: figure out how/where to define user level constants
    if session[:group_id] != nil
      return session[:group_id] > 1
    end
    store_return_to
    redirect_to login_url, alert: "Please login to do that"
  end
end
