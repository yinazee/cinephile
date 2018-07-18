class Movie < ActiveRecord::Base
  belongs_to :user
  belongs_to :director
  has_many :movie_genres
  has_many :genres, :through => :movie_genres
  validates_presence_of :name
  validates :name, uniqueness: true

  def slug
    name.downcase.gsub(" ", "-")
  end

  def self.find_by_slug(slug)
    Movie.all.find{|movie| movie.slug == slug}
  end
end
