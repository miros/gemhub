class ApplicationController < ActionController::Base
  protect_from_forgery

  private

  def authenticate_user!
    redirect_to root_path unless current_user
  end

  def current_user
    session[:user_id] && User.find(session[:user_id])
  end

  helper_method :current_user

  def log_in(user)
    session[:user_id] = user.id.to_s
  end

  def log_out
    session[:user_id] = nil
  end

end
