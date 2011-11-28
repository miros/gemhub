class RepoFetcher

  attr_reader :user

  def initialize(user, toolbox_gateway = RubyToolboxGateway.new)
    @user = user
    @toolbox_gateway = toolbox_gateway
  end

  def each(&block)
    @block = block
    each_watched_repo_page(&method(:fetch_repo))
  end

  private

    def each_watched_repo_page
      page = 0
      while (results = fetch_watched_repos(page += 1)).present? do
        repos = results.map {|info| Repo.from_github(info)}
        EM::Synchrony::FiberIterator.new(repos, 20).map {|repo| yield repo}
      end
    end

    def fetch_watched_repos(page)
      http = EM::HttpRequest.new('https://api.github.com/user/watched').get(:query => {
        access_token: user.token,
        page: page,
        per_page: 30
      })
      JSON.parse(http.response)
    end

    def fetch_repo(repo)
      @toolbox_gateway.fetch(repo)
      repo.save!
      user.repos << repo
      @block.call(repo)
    end

end