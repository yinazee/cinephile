
require 'open-uri'
require 'nokogiri'
require 'pry'

class Filmmaker
@@url = "https://digitaldreamdoor.com/pages/movie-pages/movie_directors.html"

def self.scrape_url
  #scrapes 300 directors so it could display in a drop down list
  doc = Nokogiri::HTML(open(@@url))
  list = doc.search("span").text.collect
end

end
directors_list = [

]


genres_list = [
  Comedy,
  Drama,
  Foreign,
  Animation,
  Horror,
  Autobiography,
  Science Fiction
]
