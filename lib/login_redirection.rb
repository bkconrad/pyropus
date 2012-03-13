module LoginRedirection
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
end
