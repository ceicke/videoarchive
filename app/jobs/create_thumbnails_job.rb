class CreateThumbnailsJob < ActiveJob::Base
  queue_as :default

  def perform(movie)
    movie.generate_chapter_thumbnails
    movie.generate_thumbnail
    movie.delete_tempfiles
  end
end
