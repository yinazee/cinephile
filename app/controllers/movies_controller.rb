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
        render "/movies/new"
        # render the name of the template
      else

        @movie = current_user.movies.build(params[:movie])
        # @movie.name = params[:movie][:name]
        # @movie.rating = params[:movie][:rating]
        # @movie.review = params[:movie][:review]
        if !params[:director][:director_id].blank? && !params[:director][:name].blank?
            flash[:message] = "Please select only one director."
            render "/movies/new"
            # redirect to "/users/#{current_user.slug}/movies/new"
        elsif !params[:director][:director_id].blank?
            @movie.director_id = Director.find(params[:director][:director_id]).id
        elsif @movie.director = Director.find_or_create_by(name: params[:director][:name])
        end


      if !params[:movie][:genre_ids].blank? && !params[:genre][:name].blank?#Genre checkbox AND New Genre
        @movie.genres << Genre.find(params[:movie][:genre_ids])#checkbox genre
        @movie.genres << Genre.create(params[:genre])#new genre
      elsif !params[:movie][:genre_ids].blank?#Genre check box only
        @movie.genres << Genre.find_by(params[:movie][:genre_ids])
      elsif !params[:genre][:name].blank?
        @movie.genres << Genre.create(params[:genre])
      end

        if @movie.save
          flash[:message] = "New movie succesfully saved!"
          redirect "/users/#{current_user.slug}/movies/#{@movie.slug}"

        # else
        #   flash[:message] = "**Please enter ALL fields**"
        #   redirect "/users/#{current_user.slug}/movies/new"
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
     @movie.update(params[:movie])

     @movie.save
     flash[:message] = "Your Movie has been updated!"
     redirect "/users/#{current_user.slug}/movies/#{@movie.slug}"
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
