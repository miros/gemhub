class Repo

  def self.each_with_categories(repos)
    EM::Synchrony::FiberIterator.new(repos, 20).map do |repo|
      repo.fetch_category
      yield repo
    end
  end

  attr_reader :attributes

  def initialize(attrs)
    @attributes = Hashie::Mash.new(attrs)
  end

  delegate :name, :to => :attributes

  def fetch_category
    http = EM::HttpRequest.new("https://www.ruby-toolbox.com/projects/#{name}").get
    return if http.response_header.status != 200
    attributes[:category_name] = parse_category(http.response)
  end

  def to_json
    attributes.to_json
  end

  private

    def parse_category(html)
      doc = Nokogiri::HTML(html)
      doc.css("div.teaser-bar a").detect(&its[:href] =~ /categories/).try(:text)
    end

end