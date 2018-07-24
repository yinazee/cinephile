class DeleteGenreIdFromMovies < ActiveRecord::Migration
  def change
    remove_column :movies, :genre_id
  end
end
