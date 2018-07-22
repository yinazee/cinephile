class RatingController < ApplicationController

  get '/users/:slug/ratings' do
    # if logged_in?
    #   @user = current_user
    #   @ratings = Rating.all
    #   erb :'/genres/genres'
    # else
    #   flash[:message] = "Please login."
    #   redirect '/login'
    # end
    erb :'ratings/ratings'
  end
end
