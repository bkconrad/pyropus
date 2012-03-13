module ApplicationHelper
  def username
    if session[:user_id] == nil
      return nil
    end

    user = User.find(session[:user_id])
    if user
      return user.name
    end
  end

  def logged_in
    if session[:user_id] == nil
      return nil
    end
    user = User.find(session[:user_id])
    return user != nil
  end
end
