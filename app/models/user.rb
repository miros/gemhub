class User

  include Mongoid::Document

  field :nick, type: String
  field :uid, type: Integer
  field :token, type: String

   has_and_belongs_to_many :repos, inverse_of: nil

  def self.from_github(auth)
    user = User.find_or_create_by(uid: auth.uid)
    user.update_attributes!(nick: auth.info.nickname, token: auth.credentials.token)
    user
  end

end