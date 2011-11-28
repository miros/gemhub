class Repo

  include Mongoid::Document

  field :html_url, type: String
  field :name, type: String
  field :category_name, type: String
  field :description, type: String

  def self.from_github(info)
    info = Hashie::Mash.new(info)

    repo = find_or_initialize_by(name: info.name)
    repo.html_url = info.html_url
    repo.description = info.description

    repo
  end

  def to_json
    attributes.to_json
  end

end