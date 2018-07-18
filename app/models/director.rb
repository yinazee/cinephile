class Director < ActiveRecord::Base
  has_many :movies
  has_many :genres, :through => :movies
  validates_presence_of :name
  validates :name, uniqueness: true

  def slug
    name.downcase.gsub(" ", "-")
  end

  def self.find_by_slug(slug)
    Director.all.find{|director| director.slug == slug}
  end

end
