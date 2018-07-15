require 'rack-flash'
require './config/environment'

class ApplicationController < Sinatra::Base

  configure do
    set :public_folder, 'public'
    set :views, 'app/views'
    enable :sessions
    set :session_secret, "cinephile_secret"
    use Rack::Flash
  end
# ============================================

  get '/' do
    @user = current_user
    @movies = Movie.all
    erb :index
  end

# ============================================
  helpers do #helper methods

    def logged_in?
      !!current_user #returns value true or false
    end

    def current_user #should return previous user or look for current user
      @current_user ||= User.find_by(id: session[:user_id]) if session[:user_id]
    end
  end


end
