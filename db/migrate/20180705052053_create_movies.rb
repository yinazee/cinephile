class CreateMovies < ActiveRecord::Migration
  def change
    create_table :movies do |t|
      t.string :name
      t.integer :rating
      t.string :review
      t.string :user_id
      t.string :director_id

      t.timestamps null: false
    end
  end
end
