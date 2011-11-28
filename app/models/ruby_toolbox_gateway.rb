class RubyToolboxGateway

  def fetch(repo)
    @repo = repo
    repo.category_name = fetch_category
  end

  private

    def fetch_category
      http = EM::HttpRequest.new("https://www.ruby-toolbox.com/projects/#{@repo.name}").get
      parse_category(http.response) if http.response_header.status != 200
    end

    def parse_category(html)
      doc = Nokogiri::HTML(html)
      doc.css("div.teaser-bar a").detect(&its[:href] =~ /categories/).try(:text)
    end

end