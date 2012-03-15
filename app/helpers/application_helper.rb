module ApplicationHelper
  include Authorization
  include Titles

  def render_and_replace(partial_name, elementId=nil)
    elementId ||= partial_name
    raw "$('##{elementId}').html(\"" + escape_javascript(render partial: "shared/#{partial_name}") + "\");"
  end

  def username
    if logged_in == nil
      return nil
    end

    user = User.find(session[:user_id])
    if user
      user.name
    end
  end
end
