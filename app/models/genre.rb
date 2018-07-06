class Genre < ActiveRecord::Base
  has_many :movie_genres
  has_many :movies, :through => :movie_genres
  #this also ties in with the directors assocaited with the movie.

  def slug
    username.downcase.gsub(" ","-")
  end

  def self.find_by_slug(slug)
    Genre.all.find {|user| user.slug == slug}
  end
end
