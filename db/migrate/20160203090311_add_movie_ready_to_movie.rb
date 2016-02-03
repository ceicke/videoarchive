class AddMovieReadyToMovie < ActiveRecord::Migration
  def change
    add_column :movies, :movie_ready, :boolean, default: false
  end
end
