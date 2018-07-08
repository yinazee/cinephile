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

  post '/users/teas' do
      if params.values.any? {|value| value == ""}
        flash[:message] = "Please enter ALL fields**"
        redirect "/users/#{current_user.slug}/teas/new"
      else
        @movie = current_user.movies.build(params[:movie])
        if !params[:genre][:name].blank? && @movie.genres.nil? #creating the first type by creating its params as type_name
          @movie.genres.new(name: params[:genre][:name])
        elsif !params[:genre][:name].blank? && !@movie.genres.nil? #selecting an existing type from the checkbox AND creating a new type (a tea that has more than one type)
          @movie.genres << @movie.genres.new(name: params[:genre][:name])
          @movie.genre_ids = params[:genre][:ids]
        else params[:genre][:name].blank? && !@movie.genres.nil?
          @movie.genre_ids = params[:genre][:genre_ids] #the type has already been created and is shown as checkboxes
        end
        if @movie.save
          redirect "/users/#{current_user.slug}/movies/#{@movie.id}"
        else
          redirect "/users/#{current_user.slug}/movies/new"
        end
      end
    end

end
