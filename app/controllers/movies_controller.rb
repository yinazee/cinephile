class MovieController < ApplicationController

  get '/users/:slug/movies' do
    if logged_in?
      @user = current_user
      erb :'/movies/show'
    else
      redirect '/login'
    end
  end

  get '/user/:slug/movies/new' do
    if logged_in?
      @user = current_user
      erb :'/movies/new'
    else
      redirect '/'
    end
    erb :'/movies/new'
  end

  post '/users/:slug/movies' do
      if params.values.any? {|value| value == ""}
        flash[:message] = "Please enter ALL fields**"
        redirect "/users/#{current_user.slug}/movies/new"
      else
        @movie = current_user.movies.build(params[:movie])
        @director = params[:director]
        @genre = params[:genre]

        # if !params[:genre][:name].blank? && @movie.genres.nil?
        #   #if a new genre is entered and none of the checkboxes selected
        #   @movie.genres << Genre.create(params[:name])
        # elsif !params[:genre][:name].blank? && !@movie.genres.nil?
        #   #selecting an existing type from the checkbox AND creating a new genre)
        #   @movie.genres << @movie.genres.new(name: params[:genre][:name])
        # else params[:genre][:name].blank? && !@movie.genres.nil?
        #   @movie.genre_ids = params[:genre][:genre_ids]
        #   #the type has already been created and is shown as checkboxes
        # end
        if @movie.save
          redirect "/users/#{current_user.slug}/movies/#{@movie.id}"
        else
          redirect "/users/#{current_user.slug}/movies/new"
        end
      end
    end

    get '/users/:slug/movies/:id' do
      if logged_in?
        @user = current_user
        @movie = Movie.find(params[:id])
        erb :'/movies/show'
      else
        redirect '/login'
      end
    end

    get '/users/:slug/teas/:id/edit' do
    if logged_in?
      @user = current_user
      @movie = Movie.find(params[:id])
        erb :'/movie/edit'
    else
      redirect '/login'
    end
  end

end
