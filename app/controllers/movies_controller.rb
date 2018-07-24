class MovieController < ApplicationController

  get '/users/:slug/movies' do
    if logged_in?
      @user = current_user
      erb :'/users/movies'
    else
      flash[:message] = "Please login to view your movie reviews."
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
        # render the name of the template
      else

        @movie = current_user.movies.build(params[:movie])
        if !params[:movie][:director_id].blank? && !params[:director][:name].blank?
            flash[:message] = "Please select only one director."
            redirect '/user/#{current_user.slug}/movies/new'
        elsif !params[:movie][:director_id].blank?
            @movie.director = Director.find(params[:movie][:director_id])
        elsif @movie.director = Director.find_or_create_by(name: params[:director][:name])
        end
        binding.pry
        @movie.genre_ids = params[:movie][:genre_ids]
        if !params[:genre][:name].blank?
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
     if !params[:movie][:director].blank?
       #if checkbox has value
      @movie.director = Director.find(params[:movie][:director].to_i)
     elsif @director = Director.find_or_create_by(name: params[:director][:name])
       #if new field has value then create new, then pull the id and set it to @movie.director
       @movie.director = Director.find(@director.id)
     end
     @movie.genre_ids = params[:movie][:genre_ids]
    if !params[:genre][:name].blank?
      @movie.genres << Genre.find_or_create_by(name: params[:genre][:name])
    end
    @movie.review = params[:movie][:review]
    if current_user.id == @movie.user_id.to_i
     @movie.save

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
