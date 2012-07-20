module Authorization
  USER_LEVELS = [ :unauthenticated,
                  :normal,
                  :admin ]
  # accepts a user, integer or USER_LEVELS value
  # returns an integer corresponding to a passed user
  # the index of a passed USER_LEVELS value
  # or the corresponding USER_LEVELS value of a passed integer
  def user_level arg = nil
    if arg == nil
      return session[:group_id]
    elsif arg.class == User
      return arg.group_id
    elsif USER_LEVELS.index(arg) != nil
      return USER_LEVELS.index(arg)
    end
    USER_LEVELS[arg]
  end

  def authorize
    store_return_to
    redirect_to(login_url, alert: "Please login to do that", status: 403) unless admin?
  end

  def admin?
    (user_level || 0) >= user_level(:admin)
  end

  def logged_in
    if session[:user_id] == nil
      return nil
    end
    user = User.find(session[:user_id])
    return user != nil
  end

  def log_in user
    if user === nil
      session[:user_id] = nil
      session[:group_id] = nil
    else
      session[:user_id] = user.id
      session[:group_id] = user.group_id
    end
  end

  def log_out
    log_in nil
  end
end
