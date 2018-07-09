class GenreController < ApplicationController

  get '/genres/show' do
    @genre = Genre.all
    erb :'/genres/show'
  end
end
