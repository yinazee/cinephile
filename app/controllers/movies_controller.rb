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
    if params.values.any? {|value| value == ""}
      flash[:message] = "Please fill in all fields."
      redirect "/users/#{current_user.slug}/movies/new"
    else
      binding.pry
      
