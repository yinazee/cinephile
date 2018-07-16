class DeleteMovieFromDirectors < ActiveRecord::Migration
  def change
    remove_column :directors, :movie_id, :integer
  end
end
