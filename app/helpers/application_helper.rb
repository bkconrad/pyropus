module ApplicationHelper
  include Authorization
  include Titles

  def render_and_replace(partial_name, elementId=nil)
    elementId ||= partial_name
    raw "$('##{elementId}').html(\"" + escape_javascript(render partial: "shared/#{partial_name}") + "\");"
  end

  def username
    if user_level == nil
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

  def admin?
    if user_level != nil
      user_level >= user_level(:admin)
    end
  end
end
