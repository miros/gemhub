class SessionsController < ApplicationController

  def create
    user = User.from_github(auth)
    log_in(user)
    redirect_to watched_repos_path
  end

  private

  def auth
    request.env['omniauth.auth']
  end

end
