class AddThumbnailReadyToMovie < ActiveRecord::Migration
  def change
    add_column :movies, :thumbnail_ready, :boolean, default: false
  end
end
