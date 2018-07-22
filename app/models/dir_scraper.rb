class DirScraper < ActiveRecord::Base

  @@url = "https://digitaldreamdoor.com/pages/movie-pages/movie_directors.html"

  def self.scrape_url
    #scrapes 300 directors so it could display in a drop down list
    doc = Nokogiri::HTML(open(@@url))
    list = doc.search("tbody td.td16a div.list").text.split("\n")
    x_list = list.delete_if{|i|i== ""}
    # there were ""(blanks) in the list on the website, list.count = 300

    # get rid of number from name here
    name_array = x_list.collect do |director|
                  num_out = director.split(' ')
                  # ex: ["  5.", "D.", "W.", "Griffith"]
                  name = num_out.slice(1, num_out.size).join(' ')
                  # ex: ["D. W. Griffith"]
                end

    name_order = name_array.sort
    name_array.collect.each do |name|
    Director.create(name: name)

    end
  end

end
