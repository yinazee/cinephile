class UserController < ApplicationController

  get '/signup' do
    if !logged_in?
      erb :'/users/signup'
    else
      flash[:message] = "You're logged in. Here are your movie reviews."
      redirect "/users/#{@user.slug}"
    end
  end

  post '/signup' do
    if params.has_value?("")
      flash[:message] = "Enter all fields."
      redirect "/signup"
    else
      @user = User.new(params[:user])
      if @user.save
        session[:user_id] = @user.id
        redirect "/users/#{@user.slug}"
      # else
      #   flash[:message] = "There was a problem creating this account!"
      #   erb :'/users/signup'
      end
    end
  end

  get '/' do
    if !logged_in?
      erb :'/users/login'
    else
      redirect "/users/#{@user.slug}"
    end
  end

  post '/login' do
    # if Director.count < 300
    #   DirScraper.scrape_url
    # end

    @user = User.find_by_slug(params[:username])
    if @user && @user.authenticate(params[:password])
      session[:user_id] = @user.id
      redirect "/users/#{@user.slug}"
    else
      flash[:message] = "Hm. Looks like your username and password didn't match."
      redirect "/"
    end
  end

  get '/logout' do
    if !logged_in?
      redirect "/"
    else
      session.destroy
      flash[:message] = "Good bye is a good gift when you wave it at me because I refuse to follow a bad advice you gave. Wave it at me and I will show you the door. - Israelmore Ayivor"
      redirect "/"
    end
  end

  get '/users/:slug' do
    @user = User.find_by(username: params[:slug])
    erb :'/users/show'
  end


end
