class MovieController < ApplicationController

  get '/users/:slug/movies' do
    if logged_in?
      @user = current_user
      erb :'/movies/show'
    else
      redirect '/login'
    end
  end

  get '/movies/new' do
    if logged_in?
      @user = current_user
      @directors = Director.all
      @genres = Genre.all
      erb :'/movies/new'
    else
      redirect '/'
    end
    erb :'/movies/new'
  end

  post '/users/:slug/movies' do
    erb :'/movies/show'
  end

end
