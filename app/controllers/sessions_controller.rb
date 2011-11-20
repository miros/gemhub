class SessionsController < ApplicationController

  def create
    session[:github_token] = user_info[:credentials][:token]
    redirect_to watched_repos_path
  end

  private

  def user_info
    request.env['omniauth.auth']
  end

end
