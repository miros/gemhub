class WatchedReposController < ApplicationController

  def index
    @repos = watched_repos.sort_by(&its['name'])
    ap @repos
  end

  private

  def watched_repos
    repos = []

    page = 0
    while (results = fetch_repos(page += 1)).present? do
      repos += results
    end

    repos
  end

  def fetch_repos(page)
    Nestful.json_get 'https://api.github.com/user/watched',
      :access_token => session[:github_token],
      :page => page,
      :per_page => 100
  end

end
