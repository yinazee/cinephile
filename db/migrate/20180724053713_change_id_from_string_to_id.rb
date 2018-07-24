class ChangeIdFromStringToId < ActiveRecord::Migration
  def change
    change_column :movies, :user_id, :integer
    change_column :movies, :director_id, :integer
  end
end
