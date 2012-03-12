class SessionController < ApplicationController
  def new
  end

  def create
    user = User.find_by_name(params[:name])
    if user and user.authenticate(params[:password])
      session[:user_id] = user.id
      redirect_to users_path, notice: "logged in as #{user.name}"
    else
      redirect_to login_url, alert: "Incorrect user/password"
    end
  end

  def destroy
    session[:user_id] = nil
    redirect_to users_url, notice: "You have been logged out"
  end
end
