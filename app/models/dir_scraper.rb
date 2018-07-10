class DirScraper < ActiveRecord::Base


  @@url = "https://digitaldreamdoor.com/pages/movie-pages/movie_directors.html"

  def self.scrape_url
    #scrapes 300 directors so it could display in a drop down list
    doc = Nokogiri::HTML(open(@@url))
binding.pry
    dirscrape = doc.search("div.list").text.gsub("\n", " ")


  end

# create object to each 300 object instance after scraping.

end
