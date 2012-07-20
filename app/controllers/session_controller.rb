class SessionController < ApplicationController
  skip_before_filter :authorize, :store_return_to
  def new
  end

  def create
    user = User.find_by_name(params[:name])
    if user and user.authenticate(params[:password])
      log_in user
      @successful = true
    end
    respond_to do |format|
      if @successful
        format.html { redirect_back }
      else
        format.html { redirect_back alert: "Incorrect user/password" }
      end
    end
  end

  def destroy
    session[:user_id] = nil
    session[:group_id] = nil
    respond_to { |format|
      format.html { redirect_back }
    }
  end
end
