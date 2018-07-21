class UserController < ApplicationController

  get '/signup' do
    if !logged_in?
      erb :'/users/signup'
    else
      redirect "/users/#{@user.slug}"
    end
  end

  post '/signup' do
    if params.values.any? {|value| value == ""}
      flash[:message] = "Enter all fields."
      redirect "/signup"
    else
      @user = User.new(params[:user])
      if @user.save
        session[:user_id] = @user.id
        redirect "/users/#{@user.slug}"
      else
        flash[:message] = "There was a problem creating this account!"
        erb :'/users/signup'
      end
    end
  end

  get '/login' do
    if !logged_in?
      erb :'index'
    else
      flash[:message] = "You're logged in. Here are your movie reviews."
      redirect "/users/#{@user.slug}"
    end
  end

  post '/login' do
    if Director.count < 300
      DirScraper.scrape_url
    end
    @user = User.find_by_slug(params[:username])
    if @user && @user.authenticate(params[:password])
      session[:user_id] = @user.id
      redirect "/users/#{@user.slug}"
    else
      flash[:message] = "Username and Password didn't match. Please try again."
      redirect "/"
    end
  end

  get '/logout' do
      session.destroy
      flash[:message] = "Good night and Good luck! - Edward R. Murrow"
      redirect "/"
  end



end
