class GenreController < ApplicationController

  get '/users/:slug/genres' do
    # if logged_in?
    #   @user = current_user
    #   @genres = Genre.all
    #   erb :'/genres/genres'
    # else
    #   flash[:message] = "Please login."
    #   redirect '/login'
    # end
    erb :'genres/genres'
  end


end
