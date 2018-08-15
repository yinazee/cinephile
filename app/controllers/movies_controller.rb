class MovieController < ApplicationController

  get '/users/:slug/movies' do
    @user = current_user
    if !logged_in?
      flash[:message] = "Please login to view and create movie reviews."
      redirect '/login'
    elsif logged_in? && current_user.slug != params[:slug]
       redirect "/users/#{current_user.slug}/movies"
    else
      erb :'users/movies'
    end
  end

  get '/user/:slug/movies/new' do
    if logged_in?
      if Director.count < 300
        DirScraper.scrape_url
      end
      @user = current_user
      @genres = Genre.all
      @directors = Director.all
      erb :'/movies/new'
    else
      redirect '/'
    end
    erb :'/movies/new'
  end


   post '/users/:slug/movies' do
      if params.values.any? {|value| value == ""}
        flash[:message] = "**Please enter ALL fields**"
        redirect '/user/#{current_user.slug}/movies/new'
      else
        @movie = current_user.movies.build(params[:movie])

        if !params[:movie][:director_id].blank? && !params[:director][:name].blank?
          #if checkbox and new director selected
            flash[:message] = "Please select only one director."
            render '/user/#{current_user.slug}/movies/new'
        elsif !params[:movie][:director_id].blank?
          #current director
            @movie.director = Director.find(params[:movie][:director_id])
        elsif @movie.director = Director.find_or_create_by(name: params[:director][:name])
          #new director
        end

        @movie.genre_ids = params[:movie][:genre_ids]
        #sets variable to all genres
        if !params[:genre][:name].blank?
          #if new genre, create it
          @movie.genres << Genre.find_or_create_by(name: params[:genre][:name])
        end

        if @movie.save
          flash[:message] = "New movie succesfully saved!"
          redirect "/users/#{current_user.slug}/movies/#{@movie.slug}"
        end
      end
    end


    get '/users/:user_slug/movies/:movie_slug' do
      if logged_in?
        @user = current_user
        @movie = Movie.find_by_slug(params[:movie_slug])
        erb :'/movies/show'
      else
        redirect '/login'
      end
    end

    get '/users/:user_slug/movies/:movie_slug/edit' do
    if logged_in?
      @user = current_user
      @genres = Genre.all
      @movie = Movie.find_by_slug(params[:movie_slug])
      erb :'/movies/edit'
    else
      redirect '/login'
    end
  end

  patch '/users/:user_slug/movies/:movie_slug' do
    if params.values.any? {|value| value == ""}
     flash[:message] = "Please enter all fields."
     redirect "/users/#{current_user.user_slug}/movies/#{@movie.slug}/edit"
   else
     @movie = Movie.find_by_slug(params[:movie_slug])
     @movie.name = params[:movie][:name]
     @movie.rating = params[:movie][:rating]

     if !params[:movie][:director_id].blank?
         @movie.director = Director.find(params[:movie][:director_id])
     elsif @movie.director = Director.find_or_create_by(name: params[:director][:name])
     end

     @movie.genre_ids = params[:movie][:genre_ids]
    if !params[:genre][:name].blank?
      @movie.genres << Genre.find_or_create_by(name: params[:genre][:name])
    end

     if @movie.save

     flash[:message] = "Your Movie has been updated!"
     redirect "/users/#{current_user.slug}/movies/#{@movie.slug}"
   end
 end
 end


  delete '/users/:slug/movies/:movie_slug/delete' do
    if logged_in?
     @user = current_user
     @movie = Movie.find(params[:movie_slug])
     if @movie.user_id.to_i == session[:user_id]
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
