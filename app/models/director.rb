class Director < ActiveRecord::Base
  has_many :movies
  has_many :genres, :through => :movies

  def slug
    username.downcase.gsub(" ", "-")
  end

  def self.find_by_slug(slug)
    Director.all.find{|user| user.slug == slug}
  end

end
