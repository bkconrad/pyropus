module Authorization
  def authorize
    # TODO: figure out how/where to define user level constants
    if session[:group_id] != nil
      return session[:group_id] > 1
    end
    store_return_to
    redirect_to login_url, alert: "Please login to do that"
  end
end
