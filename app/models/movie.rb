class Movie < ActiveRecord::Base
  belongs_to :user
  belongs_to :director
  has_many :movie_genres
  has_many :genres, :through => :movie_genres

  def slug
    username.downcase.gsub(" ", "-")
  end

  def self.find_by_slug(slug)
    Movie.all.find{|user| user.slug == slug}
  end
end
