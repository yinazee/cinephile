class DirScraper < ActiveRecord::Base


  @@url = "https://digitaldreamdoor.com/pages/movie-pages/movie_directors.html"

  def self.scrape_url
    #scrapes 300 directors so it could display in a drop down list
    doc = Nokogiri::HTML(open(@@url))
    list = doc.search("tbody td.td16a div.list").text.split("\n")
    list.shift
    list
    list.each do |filmmaker|
      filmmaker = Director.create
    end
    # Director objects are being created but the names are nil
    binding.pry
    # a list of filmmakers
    # filmmakers = list.slice(0, list.length)
    # the first one is nil and needs to be removed
    # will work on removing integers using g.sub
    # and then sorting them abc order ascending



  end

# create object to each 300 object instance after scraping.

end
