class WatchedReposController < ApplicationController

  before_filter :authenticate_user!

  def index
    @repos = current_user.repos
  end

end