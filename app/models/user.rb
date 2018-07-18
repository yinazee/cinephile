class User < ActiveRecord::Base
  has_many :movies
  has_secure_password
  validates_presence_of :username, :email
  validates :email, uniqueness: true

  def slug
    username.downcase.gsub(" ", "-")
  end

  def self.find_by_slug(slug)
    User.all.find{|user| user.slug == slug}
  end

end
