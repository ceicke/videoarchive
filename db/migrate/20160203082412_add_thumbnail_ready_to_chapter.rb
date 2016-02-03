class AddThumbnailReadyToChapter < ActiveRecord::Migration
  def change
    add_column :chapters, :thumbnail_ready, :boolean, default: false
  end
end
