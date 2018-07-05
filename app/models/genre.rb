class Genre < ActiveRecord::Base
  has_many :movie_genres
  has_many :movies, :through => :movie_genres


  def slug
    username.downcase.gsub(" ","-")
  end

  def self.find_by_slug(slug)
    User.all.find {|user| user.slug == slug}
  end
end
