class CreateMovieDirectors < ActiveRecord::Migration
  def change
    create_table :directors do |t|
      t.string :name
      t.integer :movie_id
      t.integer :genre_id
    end
  end
end
