class User

  include Mongoid::Document

  field :nick, type: String
  field :uid, type: Integer
  field :token, type: String

  def self.from_github(auth)
    user = User.find_or_create_by(uid: auth.uid)
    user.update_attributes!(nick: auth.info.nickname, token: auth.credentials.token)
    user
  end

  def each_watched_repo(&block)
    page = 0
    while (results = fetch_watched_repos(page += 1)).present? do
      results.each(&block)
    end
  end

  def fetch_watched_repos(page)
    http = EM::HttpRequest.new('https://api.github.com/user/watched').get(:query => {
      access_token: token,
      page: page,
      per_page: 25
    })
    JSON.parse(http.response)
  end

end