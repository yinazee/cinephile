class MovieController < ApplicationController

  get '/users/:slug/movies' do
    if logged_in?
      @user = current_user
      erb :'/moviess/index'
    else
      redirect '/login'
    end
  end

  get '/user/:slug/movies/new' do
    if logged_in?
      @user = current_user
      @directors = Director.all
      @genres = Genre.all
      erb :'/movies/new'
    else
      redirect '/login'
    end
    erb :'/movies/new'
  end


end
