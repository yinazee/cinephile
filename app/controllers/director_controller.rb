class DirectorController < ApplicationController

  get '/directors/show'
  @directors = Director.all
  # if Director.count < 300
  #   DirScraper.scrape_url
  # end
  erb :'/directors/show'
end
