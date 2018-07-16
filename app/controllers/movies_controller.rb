class MovieController < ApplicationController

  get '/users/:slug/movies' do
    if logged_in?
      @user = current_user
      erb :'/users/show'
    else
      redirect '/login'
    end
  end

  get '/user/:slug/movies/new' do
    if logged_in?
      if Director.count < 300
        DirScraper.scrape_url
      end
      @user = current_user
      @genres = Genre.all
      erb :'/movies/new'
    else
      redirect '/'
    end
    erb :'/movies/new'
  end

  post '/users/:slug/movies' do
      if params.values.any? {|value| value == ""}
        flash[:message] = "**Please enter ALL fields**"
        redirect "/users/#{current_user.slug}/movies/new"
      else
        @movie = current_user.movies.build(params[:movies])
  
        @movie.name = params[:movie][:name]
        @movie.rating = params[:movie][:rating]
        @movie.review = params[:movie][:review]
        if !params[:director][:name].blank?
          @movie.director = Director.create(params[:director])
        else
          @movie.director = Director.find(params[:director][:id])
        end
        if params[:movie][:genre_ids] && params[:genre]#Genre checkbox AND New Genre
          @movie.genres << Genre.create(params[:genre])
          @movie.genres << Genre.find_by_name(params[:movie][:genre_ids])
        elsif params[:movie][:genre_ids]#Genre check box only
          @movie.genres << Genre.find_by(params[:movie][:genre_ids])
        else #New Genre only
          @movie.genres << Genre.create(params[:genre])
        end

        if @movie.save
          flash[:message] = "New movie succesfully saved!"
          redirect "/users/#{current_user.slug}/movies/#{@movie.id}"
        else
          flash[:message] = "**Please enter ALL fields**"
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

    get '/users/:slug/movies/:id/edit' do
    if logged_in?
      @user = current_user
      @movie = Movie.find(params[:id])
        erb :'/movies/edit'
    else
      redirect '/login'
    end
  end

  patch '/users/:slug/movies/:id' do
    if params.values.any? {|value| value == ""}
     flash[:message] = "Please enter all fields."
     redirect "/users/#{current_user.slug}/movies/#{@movie.id}/edit"
   else
     @movie = Movie.find(params[:id])
     @movie.update(params[:movie])

    #  if !params[:genre][:name].blank? && @movie.genres.nil? #creating the first genre by creating its params as genre[name]
    #    @movie.genres << @movie.genres.new(name: params[:genre][:name])
    #  elsif !params[:genre][:genre_name].blank? && !@movie.genres.nil? #selecting an existing genre from the checkbox AND creating a new genre (a Movie that has more than one genre
    #    @movie.genres << @movie.genres.new(name: params[:genre][:name])
    #    new_genre = @movie.genres.last.id.to_s
    #    params[:genre][:genre_ids] << new_genre
    #  else params[:genre][:genre_name].blank? && !@movie.genres.nil?
    #    @movie.genre_ids = params[:genre][:genre_ids] #the genre has already been created and is shown as checkboxes
    #  end
     @movie.save
     flash[:message] = "Your Movie has been updated!"
     redirect "/users/#{current_user.slug}/movies/#{@movie.id}"
   end
  end

  delete '/users/:slug/movies/:id/delete' do
    if logged_in?
     @user = current_user
     @movie = Movie.find(params[:id])
     if @movie.user_id == session[:user_id]
       @movie.delete
       flash[:message] = "Movie review deleted!"
       redirect "/users/#{current_user.slug}/movies"
     else
       redirect "/users/#{current_user.slug}/movies"
     end
   else
     redirect '/'
   end
  end

end
