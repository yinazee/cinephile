class Movies < ActiveRecord::Base
  belongs_to :user

  def slug
    username.downcase.gsub(" ", "-")
  end

  def self.find_by_slug(slug)
    Movie.all.find{|user| user.slug == slug}
  end
end
